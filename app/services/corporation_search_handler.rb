class CorporationSearchHandler < SearchHandlerBase
  include ImageHelper
  
	def handle_request
		#Apply filtering
		self.search_options = {
			:select => %w{corporations.id name logo social_score participation_rate},
			:filters => {}
		}

		self.search_instance = Corporation.new
		super

		self.status = 1
	end

	def populate_result(result_hash)
		super(result_hash)

		if(self.start_offset < self.total_records)
			body = result_hash["Body"]
			body["Corporations"] = []
			corp_hash = body["Corporations"]
			self.search_object.each do |corporation|
				c = {}
				corp_hash.push(c)
				c["CorporationId"] = corporation.id
				c["Name"] = corporation.name
				c["SocialScore"] = corporation.social_score
				c["ParticipationRate"] = participation_rate_image(corporation.participation_rate)
        c["ImageUrl"] = get_corporate_image_128 corporation.logo
				if(!self.user.nil?)
					c["SupportType"] = corporation.support_type.nil? ? "-1" : corporation.support_type
				end
			end
		end
	end
end
