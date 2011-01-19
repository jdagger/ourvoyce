class CreateBarcodeLookups < ActiveRecord::Migration
  def self.up
    create_table :barcode_lookups do |t|
	t.integer :product_id
	t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :barcode_lookups
  end
end
