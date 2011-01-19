class ChangeSocialScoreType < ActiveRecord::Migration
  def self.up
	  change_column :products, :social_score, :integer
	  change_column :products, :participation_rate, :integer

	  change_column :medias, :social_score, :integer
	  change_column :medias, :participation_rate, :integer

	  change_column :corporations, :social_score, :integer
	  change_column :corporations, :participation_rate, :integer
  end

  def self.down
	  change_column :products, :social_score, :float
	  change_column :products, :participation_rate, :float

	  change_column :medias, :social_score, :float
	  change_column :medias, :participation_rate, :float

	  change_column :corporations, :social_score, :float
	  change_column :corporations, :participation_rate, :float
  end
end
