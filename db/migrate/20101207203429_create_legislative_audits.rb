class CreateLegislativeAudits < ActiveRecord::Migration
  def self.up
    create_table :legislative_audits do |t|
	t.integer :user_id
	t.integer :legislative_id
	t.integer :vote
      t.timestamps
    end
  end

  def self.down
    drop_table :legislative_audits
  end
end
