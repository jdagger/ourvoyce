class CreateZip < ActiveRecord::Migration
  def self.up
    drop_table :zips if table_exists?(:zips)
    create_table :zips do |t|
      t.string :zip
      t.integer :state_id
      t.integer :population
      t.string :latitude
      t.string :longitude
      t.string :city
      t.string :other
      t.integer :msa
    end
  end

  def self.down
  end
end
