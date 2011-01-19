class CreateCorporations < ActiveRecord::Migration
  def self.up
    create_table :corporations do |t|
      t.string :name
      t.string :logo_path

      t.timestamps
    end
  end

  def self.down
    drop_table :corporations
  end
end
