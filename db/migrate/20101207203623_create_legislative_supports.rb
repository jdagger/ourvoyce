class CreateLegislativeSupports < ActiveRecord::Migration
  def self.up
    create_table :legislative_supports, :id => false do |t|
		  t.integer :legislative_id
		  t.integer :user_id
		  t.integer :support_type
      t.timestamps
    end
  end

  def self.down
    drop_table :legislative_supports
  end
end
