class AddKeysToSupport < ActiveRecord::Migration
  def self.up
	  add_column :product_supports, :id, :primary_key
	  add_column :corporation_supports, :id, :primary_key
  end

  def self.down
	  remove_column :product_supports, :id
	  remove_column :corporation_supports, :id
  end
end
