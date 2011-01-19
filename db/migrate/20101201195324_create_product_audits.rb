class CreateProductAudits < ActiveRecord::Migration
  def self.up
    create_table :product_audits do |t|
	t.integer :user_id
	t.integer :product_id
	t.integer :vote
      t.timestamps
    end
  end

  def self.down
    drop_table :product_audits
  end
end
