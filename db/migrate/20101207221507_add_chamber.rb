class AddChamber < ActiveRecord::Migration
  def self.up
	  add_column :Legislatives, :chamber_id, :integer
  end

  def self.down
	  remove_column :Legislatives, :chamber_id
  end
end
