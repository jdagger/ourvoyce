class AddCorporateProductSupport < ActiveRecord::Migration
  def self.up
	  create_table :products_users, :id => false do |t|
		  t.integer :product_id
		  t.integer :user_id
	  end

	  create_table :corporations_users, :id => false do |t|
		  t.integer :corporation_id
		  t.integer :user_id
	  end
  end

  def self.down
	  drop_table :products_users
	  drop_table :corporations_users
  end
end
