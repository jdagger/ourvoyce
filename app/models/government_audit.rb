class GovernmentAudit < ActiveRecord::Base
	belongs_to :government
	belongs_to :user
end
