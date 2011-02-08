class MediaSupport < ActiveRecord::Base
	belongs_to :media
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
