class Product < ActiveRecord::Base
	include SearchHelper

	has_many :product_supports
	has_many :users, :through => :product_supports
	has_many :product_audits

	def initialize_search_instance
		self.search_object = Product.where("1=1")
		self.search_options[:sorting][:vote_date_column] = "product_supports.updated_at"

		if self.search_options[:include_user_support]
			self.search_options[:select] << "support_type"
			self.search_object = self.search_object.joins("LEFT OUTER JOIN product_supports ON products.id=product_supports.product_id AND user_id=#{self.search_options[:include_user_support].to_i}")
		end
	end

	class << self
		def upc_lookup(options = {})
			raise "UPC not specified" if options[:upc].nil?
			Product.where("upc = ? OR ean = ?", options[:upc], options[:upc])
		end
	end
end
