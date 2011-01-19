class LogoutHandler < HandlerBase
	def user_token
		self.request.parameters['UserToken']
	end

	def handle_request
    super
		#Try to load the record. Destory if found
		count = AuthenticationToken.delete_all(["uuid = ?", self.user_token])
		if count > 0
			self.status = 1
		else
			self.status = 0
		end
	end

	def populate_result(result_hash)
		result_hash["Body"] = {"Status" => self.status }
	end
end
