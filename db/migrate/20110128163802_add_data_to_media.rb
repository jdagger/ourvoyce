class AddDataToMedia < ActiveRecord::Migration
  def self.up
    add_column :medias, :data1, :string
    add_column :medias, :data2, :string
  end

  def self.down
    remove_column :medias, :data1
    remove_column :medias, :data2
  end
end
