class RenameGovernmentStates < ActiveRecord::Migration
  def self.up
    rename_table :government_states, :legislative_states
  end

  def self.down
    rename_table :legislative_states, :government_states
  end
end
