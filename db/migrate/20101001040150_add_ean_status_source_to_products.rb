class AddEanStatusSourceToProducts < ActiveRecord::Migration
  def self.up
	  add_column :products, :ean, :string
	  add_column :products, :source, :string
	  add_column :products, :found, :string
	  add_column :products, :status, :string
	  add_column :products, :message, :string
  end

  def self.down
	  remove_column :products, :ean
	  remove_column :products, :source
	  remove_column :products, :found
	  remove_column :products, :status
	  remove_column :products, :message
  end
end
