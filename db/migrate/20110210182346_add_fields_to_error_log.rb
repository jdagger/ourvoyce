class AddFieldsToErrorLog < ActiveRecord::Migration
  def self.up
    add_column :error_logs, :request, :text
    add_column :error_logs, :response, :text
    add_column :error_logs, :device_type, :string
    add_column :error_logs, :user, :string
  end

  def self.down
    remove_column :error_logs, :request
    remove_column :error_logs, :response
    remove_column :error_logs, :device_type
    remove_column :error_logs, :user
  end
end
