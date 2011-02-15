class CorporationSearchHandler < SearchHandlerBase
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

		if self.request.filters["PARTICIPATIONRATE"]
			search_options[:participation_rate] = self.request.filters["PARTICIPATIONRATE"].to_i
		end

		if self.request.filters["SOCIALSCORE"]
			search_options[:social_score] = self.request.filters["SOCIALSCORE"].to_i
		end

    if !(self.request.sort_name.blank? || self.request.sort_direction.blank?)
      search_options[:sort] = "#{self.request.sort_name}_#{self.request.sort_direction}"
      #search_options[:sort_name] = self.request.sort_name
      #search_options[:sort_direction] = self.request.sort_direction
    end


    self.search_object = Corporation.do_search search_options
    self.total_records = self.search_object.count
    self.search_object = self.search_object.limit(self.max_results).offset(self.start_offset)

    self.status = 1
  end

  def populate_result(result_hash)
    super(result_hash)

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
