class AddIpToAudits < ActiveRecord::Migration
  def self.up
    add_column :corporate_audits, :ip, :string
    add_column :government_audits, :ip, :string
    add_column :media_audits, :ip, :string
    add_column :product_audits, :ip, :string
  end

  def self.down
    remove_column :corporate_audits, :ip
    remove_column :government_audits, :ip
    remove_column :media_audits, :ip
    remove_column :product_audits, :ip
  end
end
