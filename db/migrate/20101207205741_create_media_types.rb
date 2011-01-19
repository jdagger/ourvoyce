class CreateMediaTypes < ActiveRecord::Migration
  def self.up
    create_table :media_types do |t|
	    t.string :name
    end
  end

  def self.down
    drop_table :media_types
  end
end
