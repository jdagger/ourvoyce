class RenameVoteToSupportType < ActiveRecord::Migration
  def self.up
	  rename_column :government_audits, :vote, :support_type
	  rename_column :media_audits, :vote, :support_type
  end

  def self.down
	  rename_column :government_audits, :support_type, :vote
	  rename_column :media_audits, :support_type, :vote
  end
end
