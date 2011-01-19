class AddWikipediaToMedia < ActiveRecord::Migration
  def self.up
	  add_column :medias, :wikipedia, :string
  end

  def self.down
	  remove_column :medias, :wikipedia
  end
end
