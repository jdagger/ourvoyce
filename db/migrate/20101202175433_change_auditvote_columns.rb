class ChangeAuditvoteColumns < ActiveRecord::Migration
  def self.up
	  rename_column :product_audits, :vote, :support_type
	  rename_column :corporate_audits, :vote, :support_type
  end

  def self.down
	  rename_column :product_audits, :support_type, :vote
	  rename_column :corporate_audits, :support_type, :vote
  end
end
