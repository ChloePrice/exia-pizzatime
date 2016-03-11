class OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :validate_token, except: [:create]


  # Get the list of orders
  #
  # == Returns:
  # An array containing pizzas ans users'name.
  #
  def index
    render json: Order.get_order_list
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
    return self.index if(params[:id].to_i == 0)
    u = User.find(params[:id])
    render json: u.pizzas
  end

  # Create a new order
  #
  # == Parameters
  # email_user::
  #   Email of user
  # id_pizza::
  #   array containing the ids of pizza
  def create
    u = User.find_by(email: order_parameters[:email_user])
    u = User.create!(email: order_parameters[:email_user], name: order_parameters[:email_user].split('@').first) if u.blank?
    u.pizzas = Pizza.where(id: order_parameters[:id_pizza]).all
    render json: u.save!
  end

  # Display a summary of the orders sorted by pizzas
  #
  # == Returns:
  # An array containing a name of a pizza, and the quantity of each one.
  #
  def summary
    render json: Order.order_summary
  end

  # Print the total price for all the current orders
  #
  # == Returns:
  # The price.
  #
  def total
    render json: Order.total_price
  end


  private

  def order_parameters
    params.permit(:id_pizza, :email_user)
  end

end
