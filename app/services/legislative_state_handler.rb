class LegislativeStateHandler < HandlerBase
  include ImageHelper

  attr_accessor :states

	def handle_request
    super
    self.states = LegislativeState.find(:all, :include => "state", :order => "states.name asc")
    self.status = 1 
	end

	def populate_result(result_hash)
		result_hash["Body"] = {"Status" => self.status }
    result_hash["Body"]["States"] = []
    self.states.each do |legislative_state|
      result_hash["Body"]["States"] << {"StateID" => legislative_state.state.id, "Logo" => get_state_image_128(legislative_state.state.logo), "Abbreviation" => legislative_state.state.abbreviation, "Name" => legislative_state.state.name, "SocialScore" => legislative_state.social_score, "ParticipationRate" => participation_rate_image(legislative_state.participation_rate)}
    end
	end
end
