class CreateExecutiveSupports < ActiveRecord::Migration
  def self.up
    create_table :executive_supports, :id => false do |t|
		  t.integer :executive_id
		  t.integer :user_id
		  t.integer :support_type
	      t.timestamps
    end
  end

  def self.down
    drop_table :executive_supports
  end
end
