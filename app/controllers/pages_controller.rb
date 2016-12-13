###
#  Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
#  See LICENSE in the project root for license information.
##

# The controller manages the interaction of the pages with
# the v2 authentication endpoint and the Microsoft Graph
# To see how to get tokens for your app look at login and callback
# To see how to send an email using the graph.microsoft.com
# endpoint see send_mail
# To see how to get rid of the tokens and finish the session
# in your app, see disconnect

class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Specifies endpoint for connecting to the Microsoft Graph
  GRAPH_RESOURCE = 'https://graph.microsoft.com'
  SENDMAIL_ENDPOINT = '/v1.0/me/microsoft.graph.sendmail'
  CONTENT_TYPE = 'application/json;odata.metadata=minimal;odata.streaming=true'

  # Delegates the browser to the v2 authentication OmniAuth module
  # which takes the user to a sign-in page, if we don't have tokens already
  # This sample uses an open source OAuth 2.0 library that is compatible with the Azure AD v2.0 endpoint.
  # Microsoft does not provide fixes or direct support for this library.
  # Refer to the library’s repository to file issues or for other support.
  # For more information about auth libraries see: https://azure.microsoft.com/documentation/articles/active-directory-v2-libraries/
  # omniauth-oauth2 repo:  https://github.com/intridea/omniauth-oauth2

  def index
    render_success
  end

  def login
    redirect_to '/auth/microsoft_v2_auth'
  end

  # If the user had to sign-in, the browser will redirect to this callback
  # with the authorization tokens attached

  def callback
    # Access the authentication hash for omniauth
    # and extract the auth token, user name, and email
    data = request.env['omniauth.auth']

    @email = data[:extra][:raw_info][:userPrincipalName]
    @name = data[:extra][:raw_info][:displayName]

    if User.exists?(:email => @email)
        user = User.find_by(:email => @email)
        user.last_token = data['credentials']['token']
	user.save!
    else
        user = User.create!(name: @name, email: @email)
        user.last_token = data['credentials']['token']
	user.save!
    end

    # Store token/user in Redis
    Token.store(data['credentials']['token'], user)

    redirect_to("http://pizzatime.ovh/?name=#{CGI.escape(user.name)}&token=#{user.last_token}")
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  # rubocop:enable Metrics/AbcSize

  # Deletes the local session and redirects to root
  # the v2 endpoint doesn't currently support a logout endpoint
  # so we can't call it for a v2 logout flow
  def disconnect
    reset_session
    logger.info 'LOGOUT'
    redirect_to '/'
  end
end
