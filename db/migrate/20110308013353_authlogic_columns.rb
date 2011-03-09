class AuthlogicColumns < ActiveRecord::Migration
  def self.up
    rename_column :users, :username, :login
    add_column :users, :crypted_password, :string
    rename_column :users, :salt, :password_salt
    add_column :users, :persistence_token, :string
    add_column :users, :perishable_token, :string
    add_column :users, :login_count, :integer, :default => 0, :null => false
    add_column :users, :failed_login_count, :integer, :null => false, :default => 0
    add_column :users, :last_request_at, :datetime
    add_column :users, :current_login_at, :datetime
    add_column :users, :last_login_at, :datetime
    add_column :users, :current_login_ip, :string
    add_column :users, :last_login_ip, :string
  end

  def self.down
    rename_column :users, :login, :username
    remove_column :users, :crypted_password
    rename_column :users, :password_salt, :salt
    remove_column :users, :persistence_token
    remove_column :users, :perishable_token
    remove_column :users, :login_count
    remove_column :users, :failed_login_count
    remove_column :users, :last_request_at
    remove_column :users, :current_login_at
    remove_column :users, :last_login_at
    remove_column :users, :current_login_ip
    remove_column :users, :last_login_ip
  end
end
