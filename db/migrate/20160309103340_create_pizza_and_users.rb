class CreatePizzaAndUsers < ActiveRecord::Migration
  def change
      create_table :pizzas_users, id: false do |t|
        t.belongs_to :pizza, index: true
        t.belongs_to :user, index: true
        t.boolean :paid, null: false, default: false
        t.boolean :discontinued, null: false, default: false
        t.timestamps null: false
      end
  end
end
