class CreateMediaSupports < ActiveRecord::Migration
  def self.up
    create_table :media_supports, :id => false do |t|
		  t.integer :media_id
		  t.integer :user_id
		  t.integer :support_type
		  t.timestamps
    end
  end

  def self.down
    drop_table :media_supports
  end
end
