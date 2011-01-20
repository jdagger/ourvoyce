class CreateOurvoyceStateLookups < ActiveRecord::Migration
  def self.up
    create_table :ourvoyce_state_lookups do |t|
      t.integer :state_id
      t.integer :user_count
      t.float :percent_of_population
    end
  end

  def self.down
    drop_table :ourvoyce_state_lookups
  end
end
