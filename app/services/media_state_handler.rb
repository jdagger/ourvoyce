class MediaStateHandler < HandlerBase
  include ImageHelper

  attr_accessor :states

	def handle_request
    super
    self.states = MediaState.find(:all, :include => "state", :order => "states.name asc")
	end

	def populate_result(result_hash)
		result_hash["Body"] = {"Status" => self.status }
    result_hash["Body"]["States"] = []
    self.states.each do |media_state|
      result_hash["Body"]["States"] << {"StateID" => media_state.state.id, "Logo" => get_state_image_128(media_state.state.logo), "Abbreviation" => media_state.state.abbreviation, "Name" => media_state.state.name, "SocialScore" => media_state.social_score, "ParticipationRate" => participation_rate_image(media_state.participation_rate)}
    end
	end
end
