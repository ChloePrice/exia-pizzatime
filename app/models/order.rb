class Order< ActiveRecord::Base
  belongs_to :user
  belongs_to :pizza
  self.table_name = :pizzas_users


  scope :live, ->() { where(discontinued: false) }
  scope :paid, ->() { where(paid: true) }
  scope :unpaid, ->() { where(paid: false) }

  def self.get_order_list
    Order.live.joins(:user).joins(:pizza).order('users.name').pluck('pizzas.name', 'users.id', 'users.name', :created_at)
  end

  def self.order_summary
    Order.live.joins(:pizza).group(:pizza_id).order('pizza_count').pluck('pizzas.name', 'COUNT(pizzas_users.pizza_id) as pizza_count').to_h
  end

  def self.total_price
    Order.live.joins(:pizza).sum('pizzas.price')
  end

  def self.sales_opened?
    return Redis.current.get('sales_open') == 'true'
  end

  def self.open_sales(open)
    if open
      Redis.current.set('sales_open', true)
      Order.update_all(discontinued: true)
    else
      Redis.current.set('sales_open', false)
    end
  end

  def discontinue
    self.update(discontinued: true)
  end

  def mark_paid
    self.update(paid: true)
  end

  def delete(user)
    user.pizzas.delete_all
  end
end