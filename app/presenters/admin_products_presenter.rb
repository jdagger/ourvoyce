class AdminProductsPresenter
	attr_accessor :products
	attr_accessor :paging

	def initialize
		self.paging = PagingHelper::PagingData.new
	end

end
