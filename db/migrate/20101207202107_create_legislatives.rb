class CreateLegislatives < ActiveRecord::Migration
  def self.up
    create_table :legislatives do |t|
	    t.string :first_name
	    t.string :middle_name
	    t.string :last_name
	    t.string :title
	    t.string :active
	    t.string :political_party
	    t.integer :state_id
	    t.string :seat
	    t.string :district
	    t.string :gender
	    t.string :phone_number
	    t.string :website
	    t.string :email
	    t.float :social_score
	    t.float :participation_rate
	    t.timestamps
    end
  end

  def self.down
    drop_table :legislatives
  end
end
