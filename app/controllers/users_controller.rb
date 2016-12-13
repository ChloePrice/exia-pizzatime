class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :validate_token, except: [:authenticate]
  before_action :validate_admin, except: [:authenticate, :order]

  def index
    render json: User.all
  end

  # Create a new user
  #
  # == Parameters
  # name::
  #   Name of user
  # email::
  #   email of user
  # promo::
  #   label of user's school class
  #
  def create
    user_parameters[:name] = user_parameters[:email].split('@').first.split('.').join(' ') if user_parameters[:name].blank?
    render json: User.create!(user_parameters)
  rescue
    render_errors(user.errors.full_messages, :unprocessable_entity)
  end

  def show
    render json: User.find(params[:id])
  rescue => e
    render_errors([e.message], :unprocessable_entity)
  end

  def destroy
    user = User.find(params[:id])
    render json: user.destroy
  rescue
    render_errors(user.errors.full_messages, :unprocessable_entity)
  end

  def authenticate
    u = User.find_by(email: password_parameters[:email])
    if u.authenticated?(password_parameters[:password])
      render_success([u.authenticate(password_parameters[:password])])
    else
      render_errors([u.errors.full_messages], :unauthorized)
    end
  end

  def order
    user = User.find(User.current(request.headers[:token]))
    raise Exceptions::BadRequest if user.nil?
    o = Order.live.placedBy(user).last
    if o.nil?
      render_errors({error: "No order for this user"})
    else
      entry = {id: o.id}
      entry[:items] = o.order_items.map do |item|
        {pizzaId: item.pizza.id, baseId: item.base.id}
      end
      entry[:date] = o.created_at
      entry[:paid] = o.paid
      entry[:delivered] = o.is_delivered?
      entry[:price] = o.order_items.inject(0){|sum, i| sum + i.pizza.price}
      entry[:paymentDate] = o.payment_date
      render_success entry
    end
  end




  private

  def user_parameters
    params.permit(:email, :name, :promo)
  end

  def password_parameters
    params.permit(:email, :password)
  end
end
