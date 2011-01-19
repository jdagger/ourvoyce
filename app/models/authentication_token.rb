class AuthenticationToken < ActiveRecord::Base
	set_primary_key :uuid

	belongs_to :user

	def initialize
		super
		generate_guid
	end

	def generate_guid
	    self.uuid = UUIDTools::UUID.timestamp_create().to_s
	end
end
