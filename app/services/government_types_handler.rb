class GovernmentTypesHandler < HandlerBase
  include ImageHelper

  attr_accessor :government_types


  def handle_request
    super
    self.government_types = GovernmentType.find(:all, :order => :display_order)
  end

	def populate_result(result_hash)
		result_hash["Body"] = {"Status" => self.status }
    result_hash["Body"]["GovernmentTypes"] = []
    self.government_types.each do |government_type|
      result_hash["Body"]["GovernmentTypes"] << {"GovernmentTypeId" => government_type.id, "Name" => government_type.name, "Logo" => get_government_type_image_128(government_type.logo), "SocialScore" => government_type.social_score, "ParticipationRate" => participation_rate_image(government_type.participation_rate)}
    end
  end
end
