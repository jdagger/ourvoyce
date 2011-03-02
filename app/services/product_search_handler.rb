class ProductSearchHandler < SearchHandlerBase
  include ImageHelper

	def handle_request
    search_options = {}

    if(load_user)
      search_options[:user_id] = self.user.id
      if self.request.filters["VOTE"]
        search_options[:vote] = self.request.filters["VOTE"]
      end
    end

    #if self.request.filters["TEXT"]
      #search_options[:text] = self.request.filters["TEXT"]
    #end

		if self.request.filters["PARTICIPATIONRATE"]
			search_options[:participation_rate] = self.request.filters["PARTICIPATIONRATE"].to_i
		end

		if self.request.filters["SOCIALSCORE"]
			search_options[:social_score] = self.request.filters["SOCIALSCORE"].to_i
		end

    if !(self.request.sort_name.blank? || self.request.sort_direction.blank?)
      #search_options[:sort_name] = self.request.sort_name
      #search_options[:sort_direction] = self.request.sort_direction
      search_options[:sort] = "#{self.request.sort_name}_#{self.request.sort_direction}"
    end


    self.search_object = Product.do_search search_options
    self.total_records = self.search_object.count
    self.search_object = self.search_object.limit(self.max_results).offset(self.start_offset)


		self.status = 1
	end

	def populate_result(result_hash)
		super(result_hash)

		if(self.start_offset < self.total_records)
			body = result_hash["Body"]
			body["Products"] = []
			prod_hash = body["Products"]
			self.search_object.each do |product|
				p = {}
				prod_hash.push(p)
				p["ProductId"] = product.id
        if product.pending
          p["Name"] = product.pending_product_description.blank? ? "Pending" : product.pending_product_description
          p["Description"] = product.pending_product_description.blank? ? "Pending" : product.pending_product_description
        else
          p["Name"] = product.name
          p["Description"] = product.description
        end
        p["UPC"] = product.upc
				p["SocialScore"] = product.social_score
				p["ParticipationRate"] = participation_rate_image(product.participation_rate)
				p["ImageUrl"] = get_product_image_128 product.logo
				if(!self.user.nil?)
					p["SupportType"] = product.support_type.nil? ? "-1" : product.support_type
				end
			end
		end
	end
end
