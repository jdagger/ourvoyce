class NavigationPresenter
	attr_accessor :link_format #ex: /abc/{offset}/xyz
	attr_accessor :current_offset
	attr_accessor :records_per_page
	attr_accessor :total_record_count

	def initialize values
		self.link_format = values[:link_format] || '/{offset}'
		self.current_offset = values[:current_offset] || 0
		self.records_per_page = values[:records_per_page] || 15
		self.total_record_count = values[:total_record_count] || 0
	end

	def previous_offset
		[0, self.current_offset - self.records_per_page].max
	end

	def next_offset
		[self.total_record_count, self.current_offset + self.records_per_page].min
	end

	def next_link
		self.link_format.sub('{offset}', next_offset.to_s)
	end

	def previous_link
		if previous_offset.eql? 0
			self.link_format.sub('/{offset}', '')
		else
			self.link_format.sub('{offset}', previous_offset.to_s)
		end
	end
end