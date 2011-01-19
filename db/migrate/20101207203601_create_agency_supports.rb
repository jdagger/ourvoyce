class CreateAgencySupports < ActiveRecord::Migration
  def self.up
    create_table :agency_supports, :id => false do |t|
		  t.integer :agency_id
		  t.integer :user_id
		  t.integer :support_type
      t.timestamps
    end
  end

  def self.down
    drop_table :agency_supports
  end
end
