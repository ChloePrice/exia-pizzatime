class OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :validate_token
  before_action :check_sales_opened, only: [:create]


  # Get the list of orders
  #
  # == Returns:
  # An array containing pizzas ans users'name.
  #
  def index
    render_success(Order.get_order_list)
  end

  # Discontinue an order (not deleted)
  #
  # == Returns:
  # An array containing pizzas ans users'name.
  #
  def destroy
    Order.discontinue(params[:id])
    render_success()
  end

  # Get details for an order
  #
  # == Returns:
  # all attributes of an order
  #
  def show
    u = User.find(params[:id])
    render_success(u.pizzas)
  end

  # Create a new order
  #
  # == Parameters
  # email::
  #   Email of user
  # id_pizza::
  #   array containing the ids of pizza
  # promo::
  #   User's school class
  #
  def create
    params = order_parameters.except(:id_pizza)
    params[:name] = params[:email].split('@').first.split('.').join(' ')
    u = User.find_by(email: order_parameters[:email_user])
    u = User.create!(params) if u.blank?
    u.pizzas = Pizza.where(id: order_parameters[:id_pizza]).all
    u.save!
    render_success
  end

  # Display a summary of the orders sorted by pizzas
  #
  # == Returns:
  # An array containing a name of a pizza, and the quantity of each one.
  #
  def summary
    render_success(Order.order_summary)
  end

  # Print the total price for all the current orders
  #
  # == Returns:
  # The price.
  #
  def total
    render_success(Order.total_price)
  end

  # Allow people to place orders
  #
  def open_sales
    Order.open_sales(params[:open])
    render_success
  end

  # List unpaid orders
  #
  def unpaid_orders
    render_success(Order.unpaid)
  end

  def mark_as_paid
    orders = Order.where(user_id: params[:id])
    return render_errors(['Uh? This user has not got any order.']) if orders.blank?
    orders.each(&:mark_paid)
    render_success
  end


  private

  def order_parameters
    params.permit(:id_pizza, :email, :promo, :base)
  end

end
