class ProductVoteHandler < VoteHandlerBase
	def product_id
		self.request.parameters['ProductId']
	end

	def handle_request
    super
		self.status = 0
		if(load_user)
      ps = ProductSupport.new
      ps.remote_ip = request.remote_ip
			ps.change_support(self.product_id, self.user.id, self.support_type)
			self.status = 1
		end
	end
end
