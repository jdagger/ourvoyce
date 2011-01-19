class AddProfitRevenueToCorporation < ActiveRecord::Migration
  def self.up
	  add_column :corporations, :revenue, :decimal, :precision => 18, :scale => 0
	  add_column :corporations, :profit, :decimal, :precision => 18, :scale => 0
  end

  def self.down
	  remove_column :corporations, :revenue
	  remove_column :corporations, :profit
  end
end
