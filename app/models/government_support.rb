class GovernmentSupport < ActiveRecord::Base
	belongs_to :government
	belongs_to :user

	after_save :add_audit, :if => :support_type_changed?
	before_destroy :delete_audit

	def add_audit
		audit = GovernmentAudit.new(:user => self.user, :government => self.government, :support_type => self.support_type)
		audit.save
	end

	def delete_audit
		audit = GovernmentAudit.new(:user => self.user, :government => self.government, :support_type => -1)
		audit.save
	end

	class << self
		def change_support government_id, user_id, support_type
			government = Government.find(government_id)
			user = User.find(user_id)

			government_support = GovernmentSupport.where("government_id = ? and user_id = ?", government.id, user.id).first

			#deleting
			if(support_type.to_i < 0)
				if(!government_support.nil?)
					government_support.destroy
				end
			elsif(government_support.nil?)
				user.government_supports.create(:government => government, :support_type => support_type)
			else
				#if already exists, update
				government_support.support_type = support_type
				government_support.save
			end
		end
	end
end
