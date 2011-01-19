class CreateAgencyAudits < ActiveRecord::Migration
  def self.up
    create_table :agency_audits do |t|
	t.integer :user_id
	t.integer :agency_id
	t.integer :vote
      t.timestamps
    end
  end

  def self.down
    drop_table :agency_audits
  end
end
