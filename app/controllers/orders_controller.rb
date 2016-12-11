require 'json'

class OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :validate_token


  # Get the list of orders
  #
  # == Returns:
  # An array containing pizzas ans users'name.
  #
  def index
    result = []
    User.all.each do |u|
      user_orders = Order.live.placedBy(u)
      next if user_orders.blank?
      entry = {user: u}
      entry[:items] = user_orders.map do |o|
        {id: o.id, pizza: {id: o.pizza.id, name: o.pizza.name, base:{id: o.pizza.base.id, name: o.pizza.base.name}}, date: o.created_at, paid: o.paid, payment_date: o.payment_date, price: o.pizza.price}
      end
      entry[:date] = user_orders.last.created_at
      entry[:paid] = !user_orders.any?{|o| !o.paid}
      entry[:delivered] = !user_orders.any?{|o| !o.is_delivered?}
      entry[:price] = user_orders.inject(0){|sum, o| sum + o.pizza.price}
      entry[:payment_date] = user_orders.last.payment_date
      result.append(entry)
    end
    render_success(result)
  end

  # Discontinue an order (not deleted)
  #
  # == Returns:
  # An array containing pizzas ans users'name.
  #
  def destroy
    order = Order.find(params[:id])
    raise Exceptions::UnAuthorized if (order.user.email != session[:email] || order.discontinued)
    raise Exceptions::SalesAreClosed if o.flag == 0
    render_success(order.update!(flag: -1))
  end


  # Create a new order
  def create
    u = User.current(request.headers['token']);
    raise Exceptions::BadRequest if u.nil?
    order_list = []
    params[:items].each do |pizza|
      o = Order.new({pizza_id: pizza[:id], base_id: pizza[:base][:id], ordered_for: getCurrentEndDate()})
      o.user = u
      o.validate!
      order_list.append(o)
    end
    order_list.each{|o| o.save!}
    render_success(order_list)
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

  # price and delivered status
  #
  def update
    order = Order.find(params[:id])
    raise Exceptions::BadRequest if order.nil?
    order.deliver if update_parameters[:delivered]
    order.lock if update_parameters[:lock]
    order.pay if update_parameters[:paid]
    render_success(order)
  end

  def cancel
    order = Order.find_by(id: params[:order_id])
    raise Exceptions::BadRequest if order.nil?
    render_success(order.cancel)
  end


  private

  def order_parameters
    params.require(:user)
  end

  def update_parameters
    params.permit(:paid, :delivered, :lock)
  end

end
