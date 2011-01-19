require "builder"

class ServiceRequest
	#Header Values
	attr_accessor :access_key
	attr_accessor :vendor_id
	attr_accessor :source
	attr_accessor :version
	attr_accessor :type
	attr_accessor :query_id

	#Details Values
	attr_accessor :method
	attr_accessor :parameters
	attr_accessor :start_offset
	attr_accessor :max_results
	attr_accessor :sort_name
	attr_accessor :sort_direction
	attr_accessor :filters

	def initialize
		self.parameters = {}
		self.filters = {}
		self.start_offset = 0
		self.max_results = 20
		self.sort_name = '';
		self.sort_direction = '';
	end

	def parse(request)
		header = request[:Header]
		self.access_key = header[:AccessKey] || ''
		self.vendor_id = header[:VendorId] || ''
		self.source = header[:Source] || ''
		self.version = header[:Version] || ''
		self.type = header[:Type] || ''
		self.query_id = header[:QueryId] ||''

		details = request[:Details]
		self.method = details[:Method]

		if(details.key?(:Parameters) && details[:Parameters].key?(:Param))
			if(details[:Parameters][:Param].kind_of?(Array))
				details[:Parameters][:Param].each do |param|
					self.parameters[param[:Key]] = param[:Value]
				end
			else
				param = details[:Parameters][:Param]
				self.parameters[param[:Key]] = param[:Value]
			end
		end

		if(details.key?(:Filters) && details[:Filters].key?(:Filter))
			if(details[:Filters][:Filter].kind_of?(Array))
				details[:Filters][:Filter].each do |filter|
					self.filters[filter[:Name]] = filter[:Value]
				end
			else
				filter = details[:Filters][:Filter]
				self.filters[filter[:Name]] = filter[:Value]
			end
		end

		if(details.key?(:Limits))
			limits = details[:Limits]
			if(limits.key?(:StartOffset))
				self.start_offset = limits[:StartOffset]
			end
			if(limits.key?(:MaxResults))
				self.max_results = limits[:MaxResults]
			end
		end

		if(details.key?(:Sort))
			sort = details[:Sort]
			if(sort.key?(:Name))
				self.sort_name = sort[:Name]
			end

			if(sort.key?(:Direction))
				self.sort_direction = sort[:Direction]
			end
		end
	end
end
