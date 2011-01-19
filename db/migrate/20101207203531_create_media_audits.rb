class CreateMediaAudits < ActiveRecord::Migration
  def self.up
    create_table :media_audits do |t|
	t.integer :user_id
	t.integer :media_id
	t.integer :vote
      t.timestamps
    end
  end

  def self.down
    drop_table :media_audits
  end
end
