class CreateAgencies < ActiveRecord::Migration
  def self.up
    create_table :agencies do |t|
	t.string :name
	t.string :url
	t.float :social_score
	t.float :participation_rate
      t.timestamps
    end
  end

  def self.down
    drop_table :agencies
  end
end
