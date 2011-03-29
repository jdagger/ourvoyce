class GovernmentSupportObserver < ActiveRecord::Observer
	def after_save(government_support)
    if government_support.support_type_changed? && !government_support.bypass_audit?
      audit = GovernmentAudit.new(:user => government_support.user, :government => government_support.government, :support_type => government_support.support_type, :ip => government_support.remote_ip)
      audit.save
    end
	end

	def before_destroy(government_support)
    if !government_support.bypass_audit?
      audit = GovernmentAudit.new(:user => government_support.user, :government => government_support.government, :support_type => -1, :ip => government_support.remote_ip)
      audit.save
    end
	end
end
