class AddBirthYearIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :birth_year
  end

  def self.down
    remove_index :users, :birth_year
  end
end
