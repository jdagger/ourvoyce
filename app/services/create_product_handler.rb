class CreateProductHandler < HandlerBase

	def user_token
		self.request.parameters['UserToken']
	end

	def upc
		self.request.parameters['UPC']
	end

	def name
		self.request.parameters['Name']
	end

	def description
		self.request.parameters['Description']
	end

	def support_type
		self.request.parameters['SupportType']
	end

	def handle_request
    super

    #Try to load to product to see if it exists
		product = Product.where("upc = ? OR ean = ?", self.upc, self.upc).first
    
    #If the product was found and is not in a pending state, don't allow a new description to be entered
		if ! product.nil? && ! product.pending
			self.status = 0
    else
      if product.nil?
        #Product not found, so create and mark as pending
        product = Product.new(:upc => self.upc, :ean => self.upc, :pending => 1)
        product.save
      end

      #If user is authenticated, store vote and description
			user_id = nil
			if(load_user)
				user_id = self.user.id
        ProductSupport.change_support(product.id, user_id, self.support_type)

        #Record the new product as being scaned
        pending_product = PendingProduct.new(:product_id => product.id, :name => self.name, :description => self.description, :user_id => user_id)
        pending_product.save

        #I think product scans are already recorded on the product lookup page.  Double check --Ryan
				#ps = ProductScan.new(:user_id => user_id, :product_id => product.id)
        #ps.save
			end

			self.status = 1
		end
	end

	def populate_result(result_hash)
		result_hash["Body"] = {"Status" => self.status }
	end
end
