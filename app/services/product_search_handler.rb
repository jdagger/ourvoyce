class ProductSearchHandler < SearchHandlerBase
	def handle_request(domain)
		self.search_options = {
			:select => %w{products.id name description logo social_score participation_rate},
			:filters => {}
		}

		self.search_instance = Product.new
    super(domain)

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
				p["Name"] = product.name
				p["Description"] = product.description
				p["SocialScore"] = product.social_score
				p["ParticipationRate"] = participation_rate_image(product.participation_rate)
				p["ImageUrl"] = "http://#{self.domain}/images/products/not_found_128_128.gif"
				if(!self.user.nil?)
					p["SupportType"] = product.support_type.nil? ? "-1" : product.support_type
				end
			end
		end
	end
end
