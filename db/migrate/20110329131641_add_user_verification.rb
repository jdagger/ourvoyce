class AddUserVerification < ActiveRecord::Migration
  def self.up
    add_column :users, :verified, :integer, :default => 0
  end

  def self.down
    remove_column :users, :verified
  end
end
