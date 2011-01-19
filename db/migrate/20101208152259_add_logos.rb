class AddLogos < ActiveRecord::Migration
  def self.up
	  rename_column :corporations, :logo_path, :logo
	  rename_column :products, :image_path, :logo
	  add_column :medias, :logo, :string
	  add_column :agencies, :logo, :string
	  add_column :executives, :logo, :string
	  add_column :legislatives, :logo, :string
  end

  def self.down
	  rename_column :corporations, :logo, :logo_path
	  rename_column :products, :logo, :image_path
	  remove_column :medias, :logo
	  remove_column :agencies, :logo
	  remove_column :executives, :logo
	  remove_column :legislatives, :logo
  end
end
