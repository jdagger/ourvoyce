class AddIndexesToCorporates < ActiveRecord::Migration
  def self.up
    add_column :corporations, :keywords, :string
    add_column :corporations, :generated_indexes, :text

    add_column :medias, :keywords, :string
    add_column :medias, :generated_indexes, :text

    add_column :governments, :keywords, :string
    add_column :governments, :generated_indexes, :text
  end

  def self.down
    remove_column :corporations, :keywords
    remove_column :corporations, :generated_indexes
    
    remove_column :medias, :keywords
    remove_column :medias, :generated_indexes

    remove_column :governments, :keywords
    remove_column :governments, :generated_indexes
  end
end
