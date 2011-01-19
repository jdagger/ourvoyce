class AddEncodedLogo < ActiveRecord::Migration
  def self.up
	  add_column :corporations, :encoded_logo, :text
  end

  def self.down
	  remove_column :corporations, :encoded_logo
  end
end
