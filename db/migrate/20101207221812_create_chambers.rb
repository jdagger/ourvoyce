class CreateChambers < ActiveRecord::Migration
  def self.up
    create_table :chambers do |t|
	    t.string :name
    end
  end

  def self.down
    drop_table :chambers
  end
end
