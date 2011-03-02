class AddDefaultToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :default_include, :integer
  end

  def self.down
    remove_column :products, :default_include
  end
end
