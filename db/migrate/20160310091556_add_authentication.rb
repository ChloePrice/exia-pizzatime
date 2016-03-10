class AddAuthentication < ActiveRecord::Migration
  def change
    add_column :users, :password_hash, :string, null: false, default: 'changeme'
    add_column :users, :password_salt, :string, null: false, default: 'changeme'
  end
end
