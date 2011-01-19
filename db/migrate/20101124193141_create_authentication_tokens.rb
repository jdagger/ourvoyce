class CreateAuthenticationTokens < ActiveRecord::Migration
  def self.up
    create_table :authentication_tokens, :id => false do |t|
	    t.string :uuid, :limit => 36, :primary => true
	    t.integer :user_id
	    t.boolean :persist
      t.timestamps
    end
  end

  def self.down
    drop_table :authentication_tokens
  end
end
