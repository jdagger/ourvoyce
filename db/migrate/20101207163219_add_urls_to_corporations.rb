class AddUrlsToCorporations < ActiveRecord::Migration
  def self.up
	  add_column :corporations, :corporate_url, :string
	  add_column :corporations, :wikipedia_url, :string
  end

  def self.down
	  remove_column :corporations, :corporate_url
	  remove_column :corporations, :wikipedia_url
  end
end
