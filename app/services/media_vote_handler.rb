class MediaVoteHandler < VoteHandlerBase
	def media_id
		self.request.parameters['MediaId']
	end

	def handle_request
    super
		self.status = 0

		if(load_user)
			media = Media.find(self.media_id)

			media_support = MediaSupport.where("media_id = ? and user_id = ?", media.id, self.user.id).first

			#deleting
			if(self.support_type.to_i < 0)
				if(!media_support.nil?)
					media_support.destroy
				end
			elsif(media_support.nil?)
				self.user.media_supports.create(:media => media, :support_type => self.support_type)
			else
				#if already exists, update
				media_support.support_type = self.support_type
				media_support.save
			end
			self.status = 1
		end
	end
end
