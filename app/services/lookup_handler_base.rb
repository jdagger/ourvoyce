class LookupHandlerBase < HandlerBase
	attr_accessor :user_support
	attr_accessor :item

	def load_support(supports)
		if(supports.count == 1)
			support = supports.first
			self.user_support = support.support_type
		else
			self.user_support = "-1"
		end
	end

	def populate_result(result_hash)
		result_hash["Body"] = {}
		body = result_hash["Body"]
		body["Status"] = self.status
	end
end
