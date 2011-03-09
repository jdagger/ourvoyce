class RemoveOldPassword < ActiveRecord::Migration
  def self.up
    remove_column :users, :hashed_password
  end

  def self.down
    add_column :users, :hashed_password, :string
  end
end
