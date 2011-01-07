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

	def handle_request(domain)
    super(domain)
		product = Product.where("upc = ? OR ean = ?", self.upc, self.upc)
		if(product.count > 0)
			self.status = 0
		else
			user_id = nil
			if(load_user)
				user_id = self.user.id
			end

			product = Product.new(:upc => self.upc, :name => self.name, :description => self.description)
			product.save

			pending_product = PendingProduct.new(:upc => self.upc, :name => self.name, :description => self.description, :support_type => self.support_type, :user_id => user_id)
			pending_product.save
			self.status = 1
		end
	end

	def populate_result(result_hash)
		result_hash["Body"] = {"Status" => self.status }
	end
end
