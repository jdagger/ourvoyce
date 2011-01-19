class ChangeUserZipCodeType < ActiveRecord::Migration
  def self.up
	  remove_column :users, :zip_code
	  add_column :users, :zip_code, :string
  end

  def self.down
	  remove_column :users, :zip_code
	  add_column :users, :zip_code, :integer
  end
end
