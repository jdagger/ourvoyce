class AddUserCount < ActiveRecord::Migration
  def self.up
    add_column :zips, :user_count, :integer
    add_column :states, :user_count, :integer
  end

  def self.down
    remove_column :zips, :user_count
    remove_column :states, :user_count
  end
end
