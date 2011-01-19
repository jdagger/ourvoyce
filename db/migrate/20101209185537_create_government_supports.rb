class CreateGovernmentSupports < ActiveRecord::Migration
  def self.up
    create_table :government_supports do |t|
		  t.integer :government_id
		  t.integer :user_id
		  t.integer :support_type
      t.timestamps
    end
  end

  def self.down
    drop_table :government_supports
  end
end
