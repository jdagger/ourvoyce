class ChangePersistType < ActiveRecord::Migration
  def self.up
	  remove_column :authentication_tokens, :persist
	  add_column :authentication_tokens, :persist, :string

  end

  def self.down
	  remove_column :authentication_tokens, :persist
	  add_column :authentication_tokens, :persist, :boolean
  end
end
