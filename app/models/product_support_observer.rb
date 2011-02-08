class ProductSupportObserver < ActiveRecord::Observer
	def after_save(product_support)
    if product_support.support_type_changed? && !product_support.bypass_audit?
      audit = ProductAudit.new(:user => product_support.user, :product => product_support.product, :support_type => product_support.support_type)
      audit.save
    end
	end

	def before_destroy(product_support)
    if !product_support.bypass_audit?
      audit = ProductAudit.new(:user => product_support.user, :product => product_support.product, :support_type => -1)
      audit.save
    end
	end

end
