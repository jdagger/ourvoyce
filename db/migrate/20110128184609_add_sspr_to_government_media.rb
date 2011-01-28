class AddSsprToGovernmentMedia < ActiveRecord::Migration
  def self.up
    add_column :government_types, :social_score, :integer
    add_column :government_types, :participation_rate, :integer
    add_column :government_types, :display_order, :integer
    add_column :media_types, :social_score, :integer
    add_column :media_types, :participation_rate, :integer
  end

  def self.down
    remove_column :government_types, :social_score
    remove_column :government_types, :participation_rate
    remove_column :government_types, :display_order
    remove_column :media_types, :social_score
    remove_column :media_types, :participation_rate
  end
end
