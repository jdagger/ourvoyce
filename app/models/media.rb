class Media < ActiveRecord::Base
	include SearchHelper

	has_many :media_supports
	has_many :users, :through => :media_supports
	has_many :media_audits

	def initialize_search_instance
		self.search_object = Media.where("1=1")

		self.search_options[:sorting][:vote_date_column] = "media_supports.updated_at"

		if self.search_options[:include_user_support]
			self.search_options[:select] << "support_type"
			self.search_object = self.search_object.joins("LEFT OUTER JOIN media_supports ON medias.id=media_supports.media_id AND user_id=#{self.search_options[:include_user_support].to_i}")
		end
	end

	def apply_custom_filters
		filters = self.search_options[:filters]
		if filters[:parent_id]
			self.search_object = self.search_object.where("parent_media_id = ?", filters[:parent_id])
		end

		if filters[:media_type]
			self.search_object = self.search_object.where("media_type_id = ?", filters[:media_type])
		end
	end

	class << self
		def media_lookup id
			begin
				return Media.find id
			rescue
				return nil
			end
		end
	end
end
