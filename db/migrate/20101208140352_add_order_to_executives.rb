class AddOrderToExecutives < ActiveRecord::Migration
  def self.up
	  add_column :executives, :default_order, :integer
  end

  def self.down
	  remove_column :executives, :default_order
  end
end
