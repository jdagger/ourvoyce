class MediaSearchHandler < SearchHandlerBase
	def handle_request(domain)
		self.search_options = {
			:select => %w{medias.id name logo parent_media_id media_type_id social_score participation_rate},
			:filters => {}
		}
		self.search_instance = Media.new
		super(domain)
		self.status = 1
	end

	def populate_result(result_hash)
		super(result_hash)

		if(self.start_offset < self.total_records)
			body = result_hash["Body"]
			body["Medias"] = []
			media_hash = body["Medias"]
			self.search_object.each do |media|
				m = {}
				media_hash.push(m)
				m["MediaId"] = media.id
				m["Name"] = media.name
				m["ParentId"] = media.parent_media_id
				m["MediaType"] = media.media_type_id
				m["SocialScore"] = media.social_score
				m["ParticipationRate"] = participation_rate_image(media.participation_rate)
				m["ImageUrl"] = "http://#{self.domain}/images/corporate_logos/not_found_128_128.gif"
				if(!self.user.nil?)
					m["SupportType"] = media.support_type.nil? ? "-1" : media.support_type
				end
			end
		end
	end
end
