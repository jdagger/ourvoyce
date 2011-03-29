class CorporationVoteHandler < VoteHandlerBase
	def corporation_id
		self.request.parameters['CorporationId']
	end

	def handle_request
    super
		self.status = 0
		if(load_user)
			#CorporationSupport.change_support(self.corporation_id, self.user.id, self.support_type)
      cs = CorporationSupport.new
      cs.remote_ip = request.remote_ip
			cs.change_support(self.corporation_id, self.user.id, self.support_type)

			self.status = 1
		end
	end

end
