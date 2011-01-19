class CreateCorporateAudits < ActiveRecord::Migration
  def self.up
    create_table :corporate_audits do |t|
	t.integer :user_id
	t.integer :corporation_id
	t.integer :vote
        t.timestamps
    end
  end

  def self.down
    drop_table :corporate_audits
  end
end
