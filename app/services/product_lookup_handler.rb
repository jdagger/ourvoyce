class ProductLookupHandler < LookupHandlerBase
	def upc
		self.request.parameters['UPC']
	end

	def handle_request(domain)
    super(domain)
		products = Product.upc_lookup :upc => self.upc

		if(products.count == 0)
			self.status = 0
			return
		else
			#product was found, so populate values
			self.status = 1
			self.item = products.first

			if(load_user)
				load_support(ProductSupport.where("user_id = ? AND product_id = ?", self.user.id, self.item.id))

				#Save the product scan
				ps = ProductScan.new(:user_id => self.user.id, :product_id => self.item.id)
				ps.save
			end
		end

	end

	def populate_result(result_hash)
		super(result_hash)

		body = result_hash["Body"]

		#if product was found, return the name
		if(self.status != 0)
			body["ProductId"] = self.item.id
			body["Name"] = self.item.name
			body["Description"] = self.item.description
			body["ImageUrl"] = "http://#{self.domain}/images/products/not_found_128_128.gif"
		end

		#if user token specified, return the support
		if(!self.user.nil?)
			body["UserSupport"] = self.user_support
		end
	end
end
