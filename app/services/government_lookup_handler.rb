class GovernmentLookupHandler < LookupHandlerBase
	def government_id
		self.request.parameters['GovernmentId']
	end

	def handle_request(domain)
    super(domain)
		self.item = Government.government_lookup(self.government_id)

		if(self.item.nil?)
			self.status = 0
			return
		end

		if(load_user)
			load_support(GovernmentSupport.where("user_id = ? AND government_id = ?", self.user.id, self.item.id))
		end
	end

	def populate_result(result_hash)
		super(result_hash)

		body = result_hash["Body"]

		if(self.status != 0)
			body["GovernmentId"] = self.item.id
			if(self.item.government_type_id == 1) #Agency
				body["Name"] = self.item.name
			else
				body["Name"] = self.item.first_name + " " + self.item.last_name
			end
			body["ImageUrl"] = "http://#{self.domain}/images/products/not_found_128_128.gif"
			body["Wikipedia"] = self.item.wikipedia
			body["Website"] = self.item.website
			body["ParticipationRate"] = participation_rate_image(self.item.participation_rate)
			body["SocialScore"] = self.item.social_score
		end

		#if user token specified, return the support
		if(!self.user.nil?)
			body["UserSupport"] = self.user_support
		end
	end
end
