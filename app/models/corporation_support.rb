class CorporationSupport < ActiveRecord::Base
	belongs_to :corporation
	belongs_to :user

	after_save :add_audit, :if => :support_type_changed?
	before_destroy :delete_audit

	def add_audit
		audit = CorporateAudit.new(:user => self.user, :corporation => self.corporation, :support_type => self.support_type)
		audit.save
	end

	def delete_audit
		audit = CorporateAudit.new(:user => self.user, :corporation => self.corporation, :support_type => -1)
		audit.save
	end

	class << self
		def change_support corporation_id, user_id, support_type
			corporation = Corporation.find(corporation_id)
			user = User.find(user_id)

			corporation_support = CorporationSupport.where("corporation_id = ? and user_id = ?", corporation.id, user.id).first

			#deleting
			if(support_type.to_i < 0)
				if(!corporation_support.nil?)
					corporation_support.destroy
				end
			elsif(corporation_support.nil?)
				user.corporation_supports.create(:corporation => corporation, :support_type => support_type)
			else
				#if already exists, update
				corporation_support.support_type = support_type
				corporation_support.save
			end
		end
	end
end
