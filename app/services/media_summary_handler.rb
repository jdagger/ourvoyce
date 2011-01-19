class MediaSummaryHandler < HandlerBase
	def handle_request
    super
	end

	def populate_result(result_hash)
		result_hash["Body"] = {}
		body = result_hash["Body"]
		body["NewspaperSocialScore"] = 10
		body["NewspaperParticipationRate"] = participation_rate_image(20)
		body["MagazineSocialScore"] = 30
		body["MagazineParticipationRate"] = participation_rate_image(40)
		body["TVSocialScore"] = 50
		body["TVParticipationRate"] = participation_rate_image(60)
		body["RadioSocialScore"] = 70
		body["RadioParticipationRate"] = participation_rate_image(80)
	end
end
