class RenameSupportTables < ActiveRecord::Migration
  def self.up
	  rename_table(:corporations_users, :corporation_supports)
	  rename_table(:products_users, :product_supports)
  end

  def self.down
	  rename_table(:corporation_supports, :corporations_users)
	  rename_table(:product_supports, :products_users)
  end
end
