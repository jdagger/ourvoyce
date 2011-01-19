class AddPendingToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :pending, :integer

    add_column :pending_products, :product_id, :integer
    remove_column :pending_products, :support_type
    remove_column :pending_products, :upc
  end

  def self.down
    remove_column :products, :pending

    remove_column :pending_products, :product_id
    add_column :pending_products, :support_type, :integer
    add_column :pending_products, :upc, :string
  end
end
