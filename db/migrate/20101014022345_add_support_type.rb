class AddSupportType < ActiveRecord::Migration
  def self.up
	  add_column :corporations_users, :type, :int
	  add_column :products_users, :type, :int
  end

  def self.down
	  remove_column :corporations_users, :type
	  remove_column :products_users, :type
  end
end
