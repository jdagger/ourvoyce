class MediaLookupHandler < LookupHandlerBase
	def media_id
		self.request.parameters['MediaId']
	end

	def handle_request(domain)
    super(domain)
		self.item = Media.media_lookup(self.media_id.to_i)

		if(self.item.nil?)
			self.status = 0
			return
		end

		if(load_user)
			load_support(MediaSupport.where("user_id = ? AND media_id = ?", self.user.id, self.item.id))
		end
	end

	def populate_result(result_hash)
		super(result_hash)

		body = result_hash["Body"]

		if(self.status != 0)
			body["MediaId"] = self.item.id
			body["Name"] = self.item.name
			body["ParentId"] = self.item.parent_media_id
			body["MediaType"] = self.item.media_type_id
			body["Wikipedia"] = self.item.wikipedia
			body["Website"] = self.item.website
			body["ImageUrl"] = "http://#{self.domain}/images/products/128_128/not_found.gif"
			body["ParticipationRate"] = participation_rate_image(self.item.participation_rate)
			body["SocialScore"] = self.item.social_score
		end

		if(!self.user.nil?)
			body["UserSupport"] = self.user_support
		end
	end
end
