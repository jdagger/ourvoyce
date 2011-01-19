class AddImagePathToProduct < ActiveRecord::Migration
  def self.up
	  add_column :products, :image_path, :string
  end

  def self.down
	  remove_column :products, :image_path
  end
end
