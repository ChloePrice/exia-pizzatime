class Order< ActiveRecord::Base
  belongs_to :user
  belongs_to :pizza
  self.table_name = :pizzas_users


  scope :live, ->() { where(discontinue: false) }

  def self.get_order_list
    Order.live.joins(:user).joins(:pizza).group('users.name').order('users.name').pluck('pizzas.name', 'users.name', :created_at)
  end

  def self.order_summary
    Order.live.joins(:pizza).group(:pizza_id).order('pizza_count').pluck('pizzas.name', 'COUNT(pizzas_users.pizza_id) as pizza_count').to_h
  end

  def self.total_price
    Order.live.joins(:pizza).sum('pizzas.price')
  end

  def self.sales_opened?
    return Redis.current.get('sales_open') == true
  end

  def discontinue
    self.update(discontinue: true)
  end

  def paid
    self.update(paid: true)
  end

  def delete(user)
    user.pizzas.delete_all
  end
end