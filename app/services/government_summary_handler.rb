class GovernmentSummaryHandler < HandlerBase

  attr_accessor :executive_ss
  attr_accessor :executive_pr

  attr_accessor :agency_ss
  attr_accessor :agency_pr

  attr_accessor :leg_ss
  attr_accessor :leg_pr

  def handle_request
    super
    gov_types = GovernmentType.find(:all, :order => :display_order)
    gov_types.each do |gov|
      case gov.id
      when 1
        self.agency_ss = gov.social_score
        self.agency_pr = gov.participation_rate
      when 2
        self.executive_ss = gov.social_score
        self.executive_pr = gov.participation_rate
      when 3
        self.leg_ss = gov.social_score
        self.leg_pr = gov.participation_rate
      end
    end
  end

	def populate_result(result_hash)
		result_hash["Body"] = {}
		result_hash["Body"] = {"Status" => self.status }
		body = result_hash["Body"]
		body["AgencySocialScore"] = self.agency_ss
		body["AgencyParticipationRate"] = participation_rate_image(self.agency_pr)
		body["ExecutiveSocialScore"] = self.executive_ss
		body["ExecutiveParticipationRate"] = participation_rate_image(self.executive_pr)
		body["LegislativeSocialScore"] = self.leg_ss
		body["LegislativeParticipationRate"] = participation_rate_image(self.leg_pr)
	end
end
