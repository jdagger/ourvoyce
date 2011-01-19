class Government < ActiveRecord::Base
	include SearchHelper

	has_many :government_supports
	has_many :users, :through => :government_supports
	has_many :government_audits

	def initialize_search_instance
		self.search_object = Government.where("1=1")

		self.search_options[:sorting][:vote_date_column] = "government_supports.updated_at"
		self.search_options[:sorting][:name_column] = self.search_options[:sorting][:name_column] || 'search_text'

		self.search_options[:filters][:text_field] = 'search_text'

		if (!self.search_options[:filters][:government_type].nil? &&
			  self.search_options[:filters][:government_type].upcase == "EXECUTIVE")
			self.search_options[:sorting][:default_sort_order] = 'default_order'
		else
			self.search_options[:sorting][:default_sort_order] = self.search_options[:sorting][:default_sort_order] || 'search_text'
		end

		if self.search_options[:include_user_support]
			self.search_options[:select] << "support_type"
			self.search_object = self.search_object.joins("LEFT OUTER JOIN government_supports ON governments.id=government_supports.government_id AND user_id=#{self.search_options[:include_user_support].to_i}")
		end
	end

	def apply_custom_filters
		filters = self.search_options[:filters]
		if filters[:state]
			self.search_object = self.search_object.where("state_id = ?", filters[:state].to_i)
		end

		if filters[:government_type]
			case filters[:government_type].upcase
			when "LEGISLATIVE"
				self.search_object = self.search_object.where("government_type_id = 3")
			when "EXECUTIVE"
				self.search_object = self.search_object.where("government_type_id = 2")
				#if(self.request.sort_name.length > 0) #If executive search and sort order not overridden, specify priority sort
				#self.sort_name = "default_order"
				#end
			when "AGENCY"
				self.search_object = self.search_object.where("government_type_id = 1")
			end

		end
	end

	class << self
		def government_lookup id
			begin
				return Government.find id
			rescue 
				return nil
			end
		end
	end
end
