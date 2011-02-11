class AddData1Data2ToGovernments < ActiveRecord::Migration
  def self.up
    add_column :governments, :data1, :string
    add_column :governments, :data2, :string
  end

  def self.down
    remove_column :governments, :data1
    remove_column :governments, :data2
  end
end
