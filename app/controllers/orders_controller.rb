class OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token


  def index
    render json: Order.get_order_list
  end

  def destroy
    Order.delete(params[:id])
  end

  def show
    u = User.find(params[:id])
    render json: u.pizzas
  end

  def create
    u = User.find_by(email: order_parameters[:email_user])
    u = User.create!(email: order_parameters[:email_user], name: order_parameters[:email_user].split('@').first) if u.blank?
    u.pizzas = Pizza.where(id: order_parameters[:id_pizza]).all
    render json: u.save!
  end

  def summary
    render json: Order.order_summary
  end

  def total
    render json: Order.total_price
  end


  private

  def order_parameters
    params.permit(:id_pizza, :email_user)
  end

end
