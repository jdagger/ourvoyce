class AddRevenuProfitTextToCorporation < ActiveRecord::Migration
  def self.up
    add_column :corporations, :revenue_text, :string
    add_column :corporations, :profit_text, :string
  end

  def self.down
    remove_column :corporations, :revenue_text
    remove_column :corporations, :profit_text
  end
end
