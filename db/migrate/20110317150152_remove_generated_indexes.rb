class RemoveGeneratedIndexes < ActiveRecord::Migration
  def self.up
    remove_column :corporations, :generated_indexes
    remove_column :governments, :generated_indexes
    remove_column :medias, :generated_indexes
  end

  def self.down
  end
end
