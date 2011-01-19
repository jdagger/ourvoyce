class MediaAudit < ActiveRecord::Base
	belongs_to :media
	belongs_to :user
end
