class VoteHandlerBase < HandlerBase
	attr_accessor :user

	def user_token
		self.request.parameters['UserToken']
	end

	def support_type
		self.request.parameters['SupportType']
	end

	def populate_result(result_hash)
		result_hash["Body"] = {}
		body = result_hash["Body"]
		body["Status"] = self.status
	end


end