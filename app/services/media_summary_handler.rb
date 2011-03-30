class MediaSummaryHandler < HandlerBase
  attr_accessor :newspaper_ss
  attr_accessor :newspaper_pr
  attr_accessor :magazine_ss
  attr_accessor :magazine_pr
  attr_accessor :tv_ss
  attr_accessor :tv_pr
  attr_accessor :radio_ss
  attr_accessor :radio_pr

	def handle_request
    super

    media_types = MediaType.all
    media_types.each do |type|
     case type.id
     when 1
       self.magazine_ss = type.social_score
       self.magazine_pr = type.participation_rate
     when 2
       self.newspaper_ss = type.social_score
       self.newspaper_pr = type.participation_rate
     when 3
       self.radio_ss = type.social_score
       self.radio_pr = type.participation_rate
     when 4
       self.tv_ss = type.social_score
       self.tv_pr = type.participation_rate
     end
    end
	end

	def populate_result(result_hash)
		result_hash["Body"] = {}
		body = result_hash["Body"]
		body["NewspaperSocialScore"] = self.newspaper_ss
		body["NewspaperParticipationRate"] = participation_rate_image(self.newspaper_pr)
		body["MagazineSocialScore"] = self.magazine_ss
		body["MagazineParticipationRate"] = participation_rate_image(self.magazine_pr)
		body["TVSocialScore"] = self.tv_ss
		body["TVParticipationRate"] = participation_rate_image(self.tv_pr)
		body["RadioSocialScore"] = self.radio_ss
		body["RadioParticipationRate"] = participation_rate_image(self.radio_pr)
	end
end
