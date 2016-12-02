class Order< ActiveRecord::Base
  belongs_to :user
  belongs_to :pizza
  self.table_name = :pizzas_users


  scope :live, ->() { where(discontinued: false).where.not(flag: -1) }
  scope :paid, ->() { where(paid: true) }
  scope :unpaid, ->() { where(paid: false) }
  scope :placedBy, -> (user) { where(user: user) }

  #Flag fields indicated state of the order
  #0 is default
  #1 is locked (ordered by phone)
  #2 is delivered
  #-1 is canceled

  def self.get_order_list
    Order.live.joins(:user).joins(:pizza).order('users.name').pluck('pizzas.name', 'users.id', 'users.name', :created_at)
  end

  def self.order_summary
    Order.live.joins(:pizza).group(:pizza_id).order('pizza_count').pluck('pizzas.name', 'COUNT(pizzas_users.pizza_id) as pizza_count').to_h
  end

  def discontinue
    raise Exceptions::BadRequest if self.flag == 1
    raise Exceptions::BadRequest if !self.paid
    return self.update(discontinued: true) 
  end

  def pay
    self.update!(paid: true, payment_date: Time.now)
    self.lock
    return true
  end

  def deliver
    return self.update(flag: 2)
  end

  def is_delivered?
    return self.flag == 2
  end

  def is_locked?
    return self.flag == 2
  end

  def cancel
    raise Exceptions::OrderLock if self.is_locked? || self.is_delivered?
    return self.update(flag: -1)
  end

  def lock
    return self.update(flag: 1)
  end

  def state
    case self.flag
      when -1
        return :canceled
      when 0
        return :default
      when 1
        return :locked
      when 2
        return :delivered
    end
  end
end