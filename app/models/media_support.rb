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

  class << self
    def change_support media_id, user_id, support_type
      media = Media.find(media_id)
      user = User.find(user_id)

      media_support = MediaSupport.where("media_id = ? and user_id = ?", media.id, user.id).first

      #deleting
      if(support_type.to_i < 0)
        if(!media_support.nil?)
          media_support.destroy
        end
        elsif(media_support.nil?)
        user.media_supports.create(:media => media, :support_type => support_type)
      else
        #if already exists, update
        media_support.support_type = support_type
        media_support.save
      end
    end
  end
end
