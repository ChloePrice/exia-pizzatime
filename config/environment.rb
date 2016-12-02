# The following values must match the client ID, secret, and reply URL
# in your Microsoft App Registration Portal entry for your app.
ENV['CLIENT_ID'] = '23bff6e3-cea3-4d0c-9b4f-012d966ccf78'
ENV['CLIENT_SECRET'] = 'rdzAez4dph0Pzmo42wNaMKb'
ENV['SCOPE'] = 'openid email profile https://graph.microsoft.com/User.Read https://graph.microsoft.com/Mail.Send'


# Load the Rails application.
require File.expand_path('../application', __FILE__)

Rails.logger = Logger.new(STDOUT)

# Initialize the Rails application.
Rails.application.initialize!


