class Corporation < ActiveRecord::Base
	include SearchHelper

	has_many :corporation_supports
	has_many :users, :through => :corporation_supports
	has_many :corporation_audits

	def initialize_search_instance
		self.search_object = Corporation.where("1=1")
		self.search_options[:sorting][:vote_date_column] = "corporation_supports.updated_at"

		if self.search_options[:include_user_support]
			self.search_options[:select] << "support_type"
			self.search_object = self.search_object.joins("LEFT OUTER JOIN corporation_supports ON corporations.id=corporation_supports.corporation_id AND user_id=#{self.search_options[:include_user_support].to_i}")
		end
	end

	class << self
		def corporation_lookup id
			begin
				return Corporation.find id
			rescue
				return nil
			end
		end
	end
end
