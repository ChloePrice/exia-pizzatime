class AddAuthentication < ActiveRecord::Migration
  def change
    add_column :users, :password_hash, :string, default: nil
    add_column :users, :password_salt, :string, default: nil
  end
end
