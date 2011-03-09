class Sessions < ActiveRecord::Migration
  def self.up
    add_index :users, :login unless index_exists?(:users, :login)
    add_index :users, :persistence_token unless index_exists?(:users, :persistence_token)
    add_index :users, :last_request_at unless index_exists?(:users, :last_request_at)

  end

  def self.down
  end
end
