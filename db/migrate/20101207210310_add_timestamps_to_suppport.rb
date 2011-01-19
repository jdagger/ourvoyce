class AddTimestampsToSuppport < ActiveRecord::Migration
  def self.up
	  add_timestamps :product_supports
	  add_timestamps :corporation_supports
  end

  def self.down
	  remove_timestamps :product_supports
	  remove_timestamps :corporation_supports
  end
end
