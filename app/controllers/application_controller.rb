class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :exception
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  # For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = 'http://pizzatime.ovh, http://admin.pizzatime.ovh'
    headers['Access-Control-Max-Age'] = "1728000"
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = 'http://pizzatime.ovh, http://admin.pizzatime.ovh'
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'application/json'
    end
  end


  ## EXCEPTION HANDLING
  rescue_from Exceptions::UnAuthorized do
    redirect_to '/login'
  end
  rescue_from Exceptions::NotAuthenticated do
    render_errors(['Who the fuck are you? (NotAuthenticated)'], :bad_request)
  end
  rescue_from Exceptions::TokenExpired do
    render_errors(['Mwhaha. This token has expired. (TokenExpired)'], 419)
  end
  rescue_from Exceptions::BadCredentials do
    render_errors(['Forgot your password, idiot? Think. Hard. (BadCredentials)'], :unauthorized)
  end
  rescue_from Exceptions::SalesAreClosed do
    render_errors(['Impossible. The sales for this date are closed.'], :unauthorized)
  end
  rescue_from Exceptions::BadRequest do
    render_errors(['The last request failed to provide the expected context to api\'s execution'], :bad_request)
  end
  rescue_from ActiveModel::StrictValidationFailed do
    render_errors(['The last request failed to provide the expected context to api\'s execution'], :bad_request)
  end



  protected

  def validate_token
    token = request.headers['token']
    raise Exceptions::UnAuthorized.new if token.blank?
    raise Exceptions::TokenExpired.new unless Token.is_valid?(token)
  end

  def check_sales_opened
    raise Exceptions::SalesAreClosed.new unless Order.sales_opened?
  end

  def render_success(object = {}, status = :ok, options = {})
    render options.merge(json: object, status: status)
  end

  def render_errors(object = {}, status = :bad_request, options = {})
    render options.merge(json: object, status: status)
  end

  def getCurrentEndDate
    return OrderEndDay.last.end_day
  end
end
