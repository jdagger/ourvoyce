class GovernmentType < ActiveRecord::Migration
  def self.up
		create_table :government_types do |t|
			t.string :name
		end
  end

  def self.down
		drop_table :government_types
  end
end
