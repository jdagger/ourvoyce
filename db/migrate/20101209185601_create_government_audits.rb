class CreateGovernmentAudits < ActiveRecord::Migration
  def self.up
    create_table :government_audits do |t|
	t.integer :user_id
	t.integer :government_id
	t.integer :vote
      t.timestamps
    end
  end

  def self.down
    drop_table :government_audits
  end
end
