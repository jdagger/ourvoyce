module PagingHelper
	class PagingData
		attr_accessor :links
		attr_accessor :current_page
		attr_accessor :total_pages

		def initialize
			self.links = []
			self.current_page = 1
			self.total_pages = 0
		end
	end
end
