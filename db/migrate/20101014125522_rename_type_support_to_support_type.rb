class RenameTypeSupportToSupportType < ActiveRecord::Migration
  def self.up
	  rename_column(:corporations_users, :type, :support_type)
	  rename_column(:products_users, :type, :support_type)
  end

  def self.down
	  rename_column(:corporations_users, :support_type, :type)
	  rename_column(:products_users, :support_type, :type)
  end
end
