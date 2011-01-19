class SupportControlPresenter
	attr_accessor :navigation
	attr_accessor :supported_ids
	attr_accessor :items
	attr_accessor :change_support_path
	attr_accessor :filter
	attr_accessor :sort

	def initialize(values)
		if !values.nil?
			self.navigation = values[:navigation] || nil
			self.supported_ids = values[:supported_ids] || {}
			self.items = values[:items] || []
			self.change_support_path = values[:change_support_path] || ''
			self.filter = values[:filter] || ''
			self.sort = values[:sort] || ''
		end
	end

	def sort_path(default)
		if self.sort == default
			if self.sort.end_with?("_asc")
				return self.sort.sub("_asc", "_desc")
			else
				return self.sort.sub("_desc", "_asc")
			end
		else
			return default
		end
	end


	def header_class(id)
		if supported_ids[id].nil?
			return "support-item-header"
		else
			if supported_ids[id] == 1
				return "support-item-thumbs-up-header"
			else
				return "support-item-thumbs-down-header"
			end
		end
	end

	def thumbs_up_class(id)
		if supported_ids[id].nil?
			return "support-item-thumbs-up"
		else
			if supported_ids[id] == 1
				return "support-item-thumbs-up-selected"
			else
				return "support-item-thumbs-up-not-selected"
			end
		end

	end

	def thumbs_down_class(id)
		if supported_ids[id].nil?
			return "support-item-thumbs-down"
		else
			if supported_ids[id] == 0
				return "support-item-thumbs-down-selected"
			else
				return "support-item-thumbs-down-not-selected"
			end
		end

	end
end
