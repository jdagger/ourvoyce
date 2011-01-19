class AddLevelToMediaTypes < ActiveRecord::Migration
  def self.up
   add_column :media_types, :level, :integer
   add_column :media_types, :display_order, :integer

    mt = MediaType.find(1) #magazine
    mt.level = 1
    mt.display_order = 3
    mt.save

    mt = MediaType.find(2) #newspaper
    mt.level = 1
    mt.display_order = 2
    mt.save

    mt = MediaType.find(3) #radio
    mt.level = 1
    mt.display_order = 4
    mt.save

    mt = MediaType.find(4) #television
    mt.level = 1
    mt.display_order = 1
    mt.save

    mt = MediaType.find(5) #TVShow
    mt.level = 2
    mt.save

    mt = MediaType.find(6) #RadioShow
    mt.level = 2
    mt.save
  end

  def self.down
    remove_column :media_types, :level
    remove_column :media_types, :display_order
  end
end
