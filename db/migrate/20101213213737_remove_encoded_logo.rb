class RemoveEncodedLogo < ActiveRecord::Migration
  def self.up
	  remove_column :corporations, :encoded_logo
  end

  def self.down
	  add_column :corporations, :encoded_logo, :text
  end
end
