class CreateErrorLogs < ActiveRecord::Migration
  def self.up
    create_table :error_logs do |t|
      t.text :message
      t.string :ip
      t.string :source
      t.timestamps
    end
  end

  def self.down
    drop_table :error_logs
  end
end
