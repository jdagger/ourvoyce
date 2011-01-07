class MediaSupport < ActiveRecord::Base
	belongs_to :media
	belongs_to :user

	after_save :add_audit, :if => :support_type_changed?
	before_destroy :delete_audit

	def add_audit
		audit = MediaAudit.new(:user => self.user, :media => self.media, :support_type => self.support_type)
		audit.save
	end

	def delete_audit
		audit = MediaAudit.new(:user => self.user, :media => self.media, :support_type => -1)
		audit.save
	end
end
