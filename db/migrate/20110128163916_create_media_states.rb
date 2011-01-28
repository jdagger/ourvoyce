class CreateMediaStates < ActiveRecord::Migration
  def self.up
    create_table :media_states do |t|
      t.integer :state_id
      t.integer :social_score
      t.integer :participation_rate
    end
  end

  def self.down
    drop_table :media_states
  end
end
