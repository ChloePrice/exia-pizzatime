class AddBaseToOrder < ActiveRecord::Migration
  def change
    add_column :pizzas_users, :base, :integer, default: 0
  end
end
