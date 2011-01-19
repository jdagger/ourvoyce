class RemoveCodeFromState < ActiveRecord::Migration
  def self.up
	  remove_column :states, :code
  end

  def self.down
	  add_column :states, :code, :string
  end
end
