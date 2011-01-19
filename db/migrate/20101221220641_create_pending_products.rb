class CreatePendingProducts < ActiveRecord::Migration
  def self.up
    create_table :pending_products do |t|
	t.string :upc
	t.string :name
	t.string :description
	t.integer :user_id
	t.integer :support_type
	t.timestamps
    end
  end

  def self.down
    drop_table :pending_products
  end
end
