class ProductSupport < ActiveRecord::Base
	belongs_to :product
	belongs_to :user

  attr_accessor :bypass_audit

  def bypass_audit?
    if self.bypass_audit.nil?
      false
    else
      self.bypass_audit
    end
  end

	class << self
		def change_support product_id, user_id, support_type
			product = Product.find(product_id)
			user = User.find(user_id)

			product_support = ProductSupport.where("product_id = ? and user_id = ?", product.id, user.id).first

			#deleting
			#if(support_type.to_i < 0)
				#if(!product_support.nil?)
					#product_support.destroy
				#end
			#elsif(product_support.nil?)
      if(product_support.nil?)
				user.product_supports.create(:product => product, :support_type => support_type)
			else
				#if already exists, update
				product_support.support_type = support_type
				product_support.save
			end
		end
	end
end
