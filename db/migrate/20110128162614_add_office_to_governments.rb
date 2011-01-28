class AddOfficeToGovernments < ActiveRecord::Migration
  def self.up
    add_column :governments, :office, :string
  end

  def self.down
    remove_column :governments, :office
  end
end
