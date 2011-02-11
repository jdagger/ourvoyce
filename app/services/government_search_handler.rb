class GovernmentSearchHandler < SearchHandlerBase
  include ImageHelper

	def handle_request
    search_options = {}

    if(load_user)
      search_options[:user_id] = self.user.id
      if self.request.filters["VOTE"]
        search_options[:vote] = self.request.filters["VOTE"]
      end
    end

    if self.request.filters["TEXT"]
      search_options[:text] = self.request.filters["TEXT"]
    end

    if self.request.filters["STATE"]
      search_options[:state] = self.request.filters["STATE"]
    end

    if self.request.filters["GOVERNMENT_TYPE"]
      search_options[:branch] = self.request.filters["GOVERNMENT_TYPE"]
    end

		if self.request.filters["PARTICIPATIONRATE"]
			search_options[:participation_rate] = self.request.filters["PARTICIPATIONRATE"].to_i
		end

		if self.request.filters["SOCIALSCORE"]
			search_options[:social_score] = self.request.filters["SOCIALSCORE"].to_i
		end

    if !(self.request.sort_name.blank? || self.request.sort_direction.blank?)
      search_options[:sort] = "#{self.request.sort_name}_#{self.request.sort_direction}"
    end

    self.search_object = Government.do_search search_options
    self.total_records = self.search_object.count
    self.search_object = self.search_object.limit(self.max_results).offset(self.start_offset)
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
				g["Title"] = government.title
				g["Office"] = government.office
				g["Type"] = government.government_type_id
				g["Data1"] = government.data1
				g["Data2"] = government.data2
				g["ImageUrl"] = get_government_image_64 government.logo, government.government_type_id, government.chamber_id
				if(!self.user.nil?)
					g["SupportType"] = government.support_type.nil? ? "-1" : government.support_type
				end
			end
		end
	end
end
