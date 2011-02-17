class MediaSearchHandler < SearchHandlerBase
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

    if self.request.filters["MEDIA_TYPE"]
      search_options[:media_type_id] = self.request.filters["MEDIA_TYPE"]
    end

    if self.request.filters["PARENT_ID"]
      search_options[:parent_media_id] = self.request.filters["PARENT_ID"]
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


    self.search_object = Media.do_search search_options
    self.total_records = self.search_object.count
    self.search_object = self.search_object.limit(self.max_results).offset(self.start_offset)
=begin
		self.search_options = {
			:select => %w{medias.id name logo parent_media_id website wikipedia media_type_id social_score participation_rate data1 data2},
			:filters => {}
		}
		self.search_instance = Media.new
		super
=end
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
				m["Data1"] = media.data1
				m["Data2"] = media.data2
        m["Website"] = media.website
        m["Wikipedia"] = media.wikipedia
				m["ParticipationRate"] = participation_rate_image(media.participation_rate)
				m["ImageUrl"] = get_media_image_128 media.logo
				if(!self.user.nil?)
					m["SupportType"] = media.support_type.nil? ? "-1" : media.support_type
				end
			end
		end
	end
end
