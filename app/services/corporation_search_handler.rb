class CorporationSearchHandler < SearchHandlerBase
	def handle_request(domain)
		#Apply filtering
		self.search_options = {
			:select => %w{corporations.id name logo social_score participation_rate},
			:filters => {}
		}

		self.search_instance = Corporation.new
		super(domain)

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
				if corporation.logo.nil?
					c["ImageUrl"] = "http://#{self.domain}/images/corporate_logos/not_found_128_128.png"
				else
					c["ImageUrl"] = "http://#{self.domain}/images/corporate_logos/#{corporation.logo}_128_128.png"
				end
				if(!self.user.nil?)
					c["SupportType"] = corporation.support_type.nil? ? "-1" : corporation.support_type
				end
			end
		end
	end
end
