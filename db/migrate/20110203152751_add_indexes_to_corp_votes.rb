class AddIndexesToCorpVotes < ActiveRecord::Migration
  def self.up
    add_index :corporation_supports, :corporation_id
    add_index :corporation_supports, :user_id
    add_index :corporation_supports, [:user_id, :corporation_id]
  end

  def self.down
  end
end
