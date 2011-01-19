class RebuildLookupTables < ActiveRecord::Migration
  def self.up
    drop_table :chambers if table_exists? :chambers
    create_table :chambers, :id => false do |t|
      t.integer :id
      t.string :name
      t.string :logo
    end

    drop_table :government_types if table_exists? :government_types
    create_table :government_types, :id => false do |t|
      t.integer :id
      t.string :name
      t.string :logo
    end

    drop_table :media_types if table_exists? :media_types
    create_table :media_types, :id => false  do |t|
      t.integer :id
      t.string :name
      t.integer :level
      t.integer :display_order
      t.string :logo
    end

    drop_table :states if table_exists? :states
    create_table :states, :id => false do |t|
      t.integer :id
      t.string :abbreviation
      t.string :name
      t.string :logo
    end
  end

  def self.down
  end
end
