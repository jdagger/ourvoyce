class ProductLookupHandler < LookupHandlerBase
  include ImageHelper

	def upc
		self.request.parameters['UPC']
	end

	def handle_request
    super
		product = Product.upc_lookup :upc => self.upc

		if(product.nil?)
			self.status = 0
			return
		else
			#product was found, so populate values
			self.status = 1
			self.item = product

      #Load default text if pending item
      if(self.item.pending)
        self.item.name = self.item.description = "Pending"
      end

			if(load_user)
				load_support(ProductSupport.where("user_id = ? AND product_id = ?", self.user.id, self.item.id))

				#Save the product scan
				ps = ProductScan.new(:user_id => self.user.id, :product_id => self.item.id)
				ps.save

        #If pending product, load user's description
        if(self.item.pending)
            pp = PendingProduct.where(:product_id => self.item.id, :user_id => self.user.id).first
            if !pp.nil?
              self.item.name = pp.name
              self.item.description = pp.description
            else
              #Product exists, but user has not provide a description, so allow them to enter a description
              self.status = 0
            end
        end
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
      body["UPC"] = self.item.upc
			body["Description"] = self.item.description
			body["ImageUrl"] = get_product_image_128 self.item.logo
    else
      body["ImageUrl"] = get_product_image_128 nil
		end

		#if user token specified, return the support
		if(!self.user.nil?)
			body["UserSupport"] = self.user_support
		end
	end
end
