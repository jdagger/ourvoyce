class CorporateAudit < ActiveRecord::Base
	belongs_to :corporation
	belongs_to :user
end
