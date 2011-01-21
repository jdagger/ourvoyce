class AddPopulationToState < ActiveRecord::Migration
  def self.up
    add_column :states, :population, :integer
  end

  def self.down
    remove_column :states, :population
  end
end
