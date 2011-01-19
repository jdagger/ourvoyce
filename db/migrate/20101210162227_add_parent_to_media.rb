class AddParentToMedia < ActiveRecord::Migration
  def self.up
	  add_column :medias, :parent_media_id, :integer
  end

  def self.down
	  remove_column :medias, :parent_media_id
  end
end
