class ProductScans < ActiveRecord::Migration
  def self.up
	create_table :product_scans do |t|
		t.integer :user_id
		t.integer :product_id
		t.timestamps
	end
  end

  def self.down
	drop_table :product_scans
  end
end
