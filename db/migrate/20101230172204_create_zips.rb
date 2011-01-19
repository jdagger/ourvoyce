class CreateZips < ActiveRecord::Migration
  def self.up
    create_table :zips do |t|
	    t.string :zip
	    t.integer :state_id
	    t.integer :population
    end
  end

  def self.down
    drop_table :zips
  end
end
