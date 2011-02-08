class CorporationSupportObserver < ActiveRecord::Observer
	def after_save(corporation_support)
    if corporation_support.support_type_changed? && !corporation_support.bypass_audit?
      audit = CorporateAudit.new(:user => corporation_support.user, :corporation => corporation_support.corporation, :support_type => corporation_support.support_type)
      audit.save
    end
	end

	def before_destroy(corporation_support)
    if !corporation_support.bypass_audit?
      audit = CorporateAudit.new(:user => corporation_support.user, :corporation => corporation_support.corporation, :support_type => -1)
      audit.save
    end
	end
end
