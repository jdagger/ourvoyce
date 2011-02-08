class MediaSupportObserver < ActiveRecord::Observer
	def after_save(media_support)
    if media_support.support_type_changed? && !media_support.bypass_audit?
      audit = MediaAudit.new(:user => media_support.user, :media => media_support.media, :support_type => media_support.support_type)
      audit.save
    end
	end

	def before_destroy(media_support)
    if !media_support.bypass_audit?
      audit = MediaAudit.new(:user => media_support.user, :media => media_support.media, :support_type => -1)
      audit.save
    end
  end
end
