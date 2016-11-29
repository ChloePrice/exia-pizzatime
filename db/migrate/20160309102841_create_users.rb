class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.timestamps null: false
      t.string :last_token
    end
  end
end
