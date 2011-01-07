class ProductSupport < ActiveRecord::Base
	belongs_to :product
	belongs_to :user

	after_save :add_audit, :if => :support_type_changed?
	before_destroy :delete_audit

	def add_audit
		audit = ProductAudit.new(:user => self.user, :product => self.product, :support_type => self.support_type)
		audit.save
	end

	def delete_audit
		audit = ProductAudit.new(:user => self.user, :product => self.product, :support_type => -1)
		audit.save
	end

	class << self
		def change_support product_id, user_id, support_type
			product = Product.find(product_id)
			user = User.find(user_id)

			product_support = ProductSupport.where("product_id = ? and user_id = ?", product.id, user.id).first

			#deleting
			if(support_type.to_i < 0)
				if(!product_support.nil?)
					product_support.destroy
				end
			elsif(product_support.nil?)
				user.product_supports.create(:product => product, :support_type => support_type)
			else
				#if already exists, update
				product_support.support_type = support_type
				product_support.save
			end
		end
	end
end