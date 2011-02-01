class LegislativeStateHandler < SearchHandlerBase
  include ImageHelper

  attr_accessor :states

	def handle_request
		self.search_options = {
			:select => %w{states.id states.logo states.abbreviation states.name social_score participation_rate},
		  :filters => {},
		}
		self.search_instance = LegislativeState.new
		super
		self.status = 1
	end

	def populate_result(result_hash)

		super(result_hash)

			body = result_hash["Body"]
			body["States"] = []
			leg_hash = body["States"]
			self.search_object.each do |leg_state|
				g = {}
				leg_hash.push(g)
				g["StateID"] = leg_state.id
        g["Abbreviation"] = leg_state.abbreviation
        g["Name"] = leg_state.name
        g["Logo"] = get_state_image_128(leg_state.logo)
				g["SocialScore"] = leg_state.social_score
				g["ParticipationRate"] = participation_rate_image(leg_state.participation_rate)
			end
	end
end
