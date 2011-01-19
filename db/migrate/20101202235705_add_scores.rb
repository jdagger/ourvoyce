class AddScores < ActiveRecord::Migration
  def self.up
	  add_column :products, :social_score, :float
	  add_column :products, :participation_rate, :float
	  add_column :corporations, :social_score, :float
	  add_column :corporations, :participation_rate, :float
  end

  def self.down
	  remove_column :products, :social_score
	  remove_column :products, :participation_rate
	  remove_column :corporations, :social_score
	  remove_column :corporations, :participation_rate
  end
end
