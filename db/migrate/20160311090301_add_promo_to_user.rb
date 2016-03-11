class AddPromoToUser < ActiveRecord::Migration
  def change
    add_column :users, :promo, :string
  end
end
