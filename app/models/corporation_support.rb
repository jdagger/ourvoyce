class CorporationSupport < ActiveRecord::Base
	belongs_to :corporation
	belongs_to :user

  attr_accessor :remote_ip
  attr_accessor :bypass_audit

  def bypass_audit?
    if self.bypass_audit.nil?
      false
    else
      self.bypass_audit
    end
  end


	#class << self
  #Refactor so already loaded, then update
		def change_support corporation_id, user_id, support_type
			corporation = Corporation.find(corporation_id)
			user = User.find(user_id)

			corporation_support = CorporationSupport.where("corporation_id = ? and user_id = ?", corporation.id, user.id).first
      if !corporation_support.nil?
        corporation_support.remote_ip = self.remote_ip
      end

			#deleting
			if(support_type.to_i < 0)
				if(!corporation_support.nil?)
					corporation_support.destroy
				end
			elsif(corporation_support.nil?)
				user.corporation_supports.create(:corporation => corporation, :support_type => support_type, :remote_ip => self.remote_ip)
			else
				#if already exists, update
				corporation_support.support_type = support_type
				corporation_support.save
			end
		end
	#end
end
