class ProductsIndexPresenter < Presenter
	attr_accessor :products
	attr_accessor :paging

=begin
	attr_accessor :support_control
	attr_accessor :user_id

	def load(user_id, offset, limit, change_support_path)
		self.user_id = user_id
		self.support_control = SupportControlPresenter.new({
				:navigation =>  NavigationPresenter.new({
					:link_format => "/products/{offset}",
					:current_offset => offset.to_i,
					:records_per_page => limit.to_i,
					:total_record_count => Product.count
				}),
				:items => [],
				:supported_ids => {},
				:change_support_path => change_support_path
		})

		#Load the products for the selected page
		products = Product.find(:all, :limit => self.support_control.navigation.records_per_page, :offset => self.support_control.navigation.current_offset)

		#Populate the presenter item array with the products
		products.each do |p|
			self.support_control.items += [SupportControlItem.new({:id => p.id, :name => p.name, :logo => '', :control => self.support_control})]
		end

		#Load the list of supported ids, along with the support type
		support = User.find(self.user_id).product_supports
		support.each do |s|
			self.support_control.supported_ids[s.product_id] = s.support_type
		end
	end
=end
end
