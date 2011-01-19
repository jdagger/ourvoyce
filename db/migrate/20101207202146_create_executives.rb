class CreateExecutives < ActiveRecord::Migration
  def self.up
    create_table :executives do |t|
	    t.string :first_name
	    t.string :middle_name
	    t.string :last_name
	    t.string :title
	    t.string :active
	    t.float :social_score
	    t.float :participation_rate
	    t.timestamps
    end
  end

  def self.down
    drop_table :executives
  end
end
