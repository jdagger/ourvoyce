class AddColumnSearchText < ActiveRecord::Migration
  def self.up
	  add_column :governments, :search_text, :string
  end

  def self.down
	  remove_column :governments, :search_text
  end
end
