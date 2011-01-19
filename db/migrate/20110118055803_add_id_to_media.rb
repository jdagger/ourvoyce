class AddIdToMedia < ActiveRecord::Migration
  def self.up
    add_column :media_supports, :id, :primary_key
  end

  def self.down
    remove_column :media_supports, :id
  end
end
