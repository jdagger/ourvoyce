class CreateExecutiveAudits < ActiveRecord::Migration
  def self.up
    create_table :executive_audits do |t|
	t.integer :user_id
	t.integer :executive_id
	t.integer :vote
      	t.timestamps
    end
  end

  def self.down
    drop_table :executive_audits
  end
end
