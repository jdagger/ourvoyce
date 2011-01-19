class CleanupGovernmentTables < ActiveRecord::Migration
  def self.up
	  drop_table :agencies
	  drop_table :agency_audits
	  drop_table :agency_supports

	  drop_table :executives
	  drop_table :executive_audits
	  drop_table :executive_supports

	  drop_table :legislatives
	  drop_table :legislative_audits
	  drop_table :legislative_supports
  end

  def self.down
	  create_table :agencies
	  create_table :agency_audits
	  create_table :agency_supports

	  create_table :executives
	  create_table :executive_audits
	  create_table :executive_supports

	  create_table :legislatives
	  create_table :legislative_audits
	  create_table :legislative_supports
  end
end
