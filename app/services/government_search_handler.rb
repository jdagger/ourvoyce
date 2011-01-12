class GovernmentSearchHandler < SearchHandlerBase
  include ImageHelper

	def handle_request(domain)
		self.search_options = {
			:select => %w{governments.id name first_name last_name government_type_id logo chamber_id social_score participation_rate},
			:filters => {}
		}
		self.search_instance = Government.new
		super(domain)
		self.status = 1
	end

	def populate_result(result_hash)
		super(result_hash)

		if(self.start_offset < self.total_records)
			body = result_hash["Body"]
			body["Governments"] = []
			gov_hash = body["Governments"]
			self.search_object.each do |government|
				g = {}
				gov_hash.push(g)
				g["GovernmentId"] = government.id
				if(government.government_type_id == 1) #Agency
					g["Name"] = government.name
				else
					g["Name"] = government.first_name + " " + government.last_name
				end
				g["SocialScore"] = government.social_score
				g["ParticipationRate"] = participation_rate_image(government.participation_rate)
				g["Type"] = government.government_type_id
				g["ImageUrl"] = get_government_image_64 government.logo, government.government_type_id, government.chamber_id
				if(!self.user.nil?)
					g["SupportType"] = government.support_type.nil? ? "-1" : government.support_type
				end
			end
		end
	end
end
