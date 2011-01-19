class CreateMedias < ActiveRecord::Migration
  def self.up
    create_table :medias do |t|
	t.string :name
	t.string :website
	t.integer :media_type_id
	t.float :social_score
	t.float :participation_rate
      t.timestamps
    end
  end

  def self.down
    drop_table :medias
  end
end
