class OrderItem< ActiveRecord::Base
  belongs_to :order
  belongs_to :pizza
  belongs_to :base
end