class AddSupportTypeIndexes < ActiveRecord::Migration
  def self.up
    add_index :corporation_supports, :corporation_id unless index_exists? :corporation_supports, :corporation_id
    add_index :corporation_supports, :user_id unless index_exists? :corporation_supports, :user_id
    add_index :corporation_supports, [:corporation_id, :user_id], :unique => true unless index_exists? :corporation_supports, [:corporation_id, :user_id]
    add_index :corporation_supports, :support_type unless index_exists? :corporation_supports, :support_type

    add_index :media_supports, :media_id unless index_exists? :media_supports, :media_id
    add_index :media_supports, :user_id unless index_exists? :media_supports, :user_id
    add_index :media_supports, [:media_id, :user_id], :unique => true unless index_exists? :media_supports, [:media_id, :user_id] 
    add_index :media_supports, :support_type unless index_exists? :media_supports, :support_type 

    add_index :government_supports, :government_id unless index_exists? :government_supports, :government_id 
    add_index :government_supports, :user_id unless index_exists? :government_supports, :user_id 
    add_index :government_supports, [:government_id, :user_id], :unique => true unless index_exists? :government_supports, [:government_id, :user_id] 
    add_index :government_supports, :support_type unless index_exists? :government_supports, :support_type 

    add_index :product_supports, :product_id unless index_exists? :product_supports, :product_id 
    add_index :product_supports, :user_id unless index_exists? :product_supports, :user_id 
    add_index :product_supports, [:product_id, :user_id], :unique => true unless index_exists? :product_supports, [:product_id, :user_id] 
    add_index :product_supports, :support_type unless index_exists?  :product_supports, :support_type 
  end

  def self.down
    remove_index :corporation_supports, :corporation_id unless !index_exists? :corporation_supports, :corporation_id
    remove_index :corporation_supports, :user_id unless !index_exists? :corporation_supports, :user_id
    remove_index :corporation_supports, [:corporation_id, :user_id] unless !index_exists? :corporation_supports, [:corporation_id, :user_id]
    remove_index :corporation_supports, :support_type unless !index_exists? :corporation_supports, :support_type

    remove_index :media_supports, :media_id unless !index_exists? :media_supports, :media_id
    remove_index :media_supports, :user_id unless !index_exists? :media_supports, :user_id
    remove_index :media_supports, [:media_id, :user_id] unless !index_exists? :media_supports, [:media_id, :user_id] 
    remove_index :media_supports, :support_type unless !index_exists? :media_supports, :support_type 

    remove_index :government_supports, :government_id unless !index_exists? :government_supports, :government_id 
    remove_index :government_supports, :user_id unless !index_exists? :government_supports, :user_id 
    remove_index :government_supports, [:government_id, :user_id] unless !index_exists? :government_supports, [:government_id, :user_id] 
    remove_index :government_supports, :support_type unless !index_exists? :government_supports, :support_type 

    remove_index :product_supports, :product_id unless !index_exists? :product_supports, :product_id 
    remove_index :product_supports, :user_id unless !index_exists? :product_supports, :user_id 
    remove_index :product_supports, [:product_id, :user_id] unless !index_exists?  :product_supports, [:product_id, :user_id] 
    remove_index :product_supports, :support_type unless !index_exists?  :product_supports, :support_type 

  end
end
