class CreateGovernments < ActiveRecord::Migration
	def self.up
		create_table :governments do |t|
			t.string :name
			t.string :first_name
			t.string :middle_name
			t.string :last_name
			t.string :title
			t.string :active
			t.string :political_party
			t.integer :state_id
			t.string :seat
			t.integer :chamber_id
			t.string :district
			t.string :gender
			t.string :phone_number
			t.string :website
			t.string :wikipedia
			t.string :logo
			t.string :email
			t.integer :government_type_id
			t.integer :default_order
			t.integer :social_score
			t.integer :participation_rate
			t.timestamps
		end
	end

	def self.down
		drop_table :governments
	end
end
