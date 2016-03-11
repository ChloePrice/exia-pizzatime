class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :exception

  ## EXCEPTION HANDLING

  rescue_from Exceptions::UnAuthorized do
    render_errors(['Screw you! You are not allowed here. (UnAuthorized)'], :unauthorized)
  end
  rescue_from Exceptions::NotAuthenticated do
    render_errors(['How the fuck are you? (NotAuthenticated)'], :bad_request)
  end
  rescue_from Exceptions::TokenExpired do
    render_errors(['Mwhaha. This token has expired. (TokenExpired)'], :bad_request)
  end
  rescue_from Exceptions::BadCredentials do
    render_errors(['Forgot your password, idiot? Think. Hard. (BadCredentials)'], :unauthorized)
  end



  protected

  def validate_token
    raise Exceptions::UnAuthorized.new if params[:token].blank?
    raise Exceptions::TokenExpired.new unless Token.is_valid?(params[:token])
  end

  def render_success(object = {}, status = :ok, options = {})
    render options.merge(json: object, status: status)
  end

  def render_errors(object = {}, status = :bad_request, options = {})
    render options.merge(json: object, status: status)
  end


end
