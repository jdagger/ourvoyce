class GovernmentSummaryHandler < HandlerBase

	def populate_result(result_hash)
		result_hash["Body"] = {}
		body = result_hash["Body"]
		body["AgencySocialScore"] = 10
		body["AgencyParticipationRate"] = participation_rate_image(20)
		body["ExecutiveSocialScore"] = 30
		body["ExecutiveParticipationRate"] = participation_rate_image(40)
		body["LegislativeSocialScore"] = 50
		body["LegislativeParticipationRate"] = participation_rate_image(60)
	end
end
