class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.string :shortcut
      t.string :logo
      t.integer :priority
      t.integer :display_myvoyce
      t.timestamps
    end

    add_column :products, :category_id, :integer

    add_index :categories, :shortcut, :unique => true
    add_index :categories, :display_myvoyce
  end

  def self.down
    drop_table :categories
    remove_index :categories, :shortcut rescue true
    remove_column :products, :category_id
  end
end
