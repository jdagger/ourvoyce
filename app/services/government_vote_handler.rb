class GovernmentVoteHandler < VoteHandlerBase
	def government_id
		self.request.parameters['GovernmentId']
	end

	def handle_request
    super
		self.status = 0
		if(load_user)
			GovernmentSupport.change_support(self.government_id, self.user.id, self.support_type)
			self.status = 1
    end
  end
end
