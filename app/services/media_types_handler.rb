class MediaTypesHandler < HandlerBase
  include ImageHelper

  attr_accessor :media_types


  def handle_request
    super
    self.media_types = MediaType.find(:all, :order => :display_order)
  end

	def populate_result(result_hash)
		result_hash["Body"] = {"Status" => self.status }
    result_hash["Body"]["MediaTypes"] = []
    self.media_types.each do |media_type|
      result_hash["Body"]["MediaTypes"] << {"MediaTypeId" => media_type.id, "Name" => media_type.name, "Level" => media_type.level, "Logo" => get_media_type_image_128(media_type.logo), "SocialScore" => media_type.social_score, "ParticipationRate" => participation_rate_image(media_type.participation_rate)}
    end
  end
end
