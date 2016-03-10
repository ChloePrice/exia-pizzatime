class CreatePizzas < ActiveRecord::Migration
  def change
    create_table :pizzas do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.decimal :price, null: false
      t.timestamps null: false
    end
  end
end
