module ImageHelper
  def get_media_image_128(image_name)
    if(image_name.nil? || image_name.empty?)
      "#{Rails.configuration.logos_domain}/images/media_logos/128_128/not_found.png"
    else
      "#{Rails.configuration.logos_domain}/images/media_logos/128_128/#{image_name}"
    end
  end

  def get_media_type_image_128(image_name)
    if(image_name.nil? || image_name.empty?)
      "#{Rails.configuration.logos_domain}/images/media_type_logos/128_128/not_found.png"
    else
      "#{Rails.configuration.logos_domain}/images/media_type_logos/128_128/#{image_name}"
    end
  end

  def get_corporate_image_128(image_name)
    if(image_name.nil? || image_name.empty?)
        "#{Rails.configuration.logos_domain}/images/corporate_logos/128_128/not_found.gif"
    else
      "#{Rails.configuration.logos_domain}/images/corporate_logos/128_128/#{image_name}"
    end
  end

  def get_state_image_128(image_name)
    if(image_name.nil? || image_name.empty?)
      "#{Rails.configuration.logos_domain}/images/state_logos/128_128/not_found.gif"
    else
      "#{Rails.configuration.logos_domain}/images/state_logos/128_128/#{image_name}"
    end
  end

  def get_government_image_64(image_name, government_type_id, chamber_id = nil)
    directory = ''
      case government_type_id.to_i
        when 1
          directory = 'agencies'
        when 2
          directory = 'executives'
        when 3
          if(chamber_id.to_i == 1)
            directory = 'representatives'
          else
            directory = 'senators'
          end
      end
      if(image_name.nil? || image_name.empty?)
        "#{Rails.configuration.logos_domain}/images/government_logos/#{directory}/64_64/not_found.gif"
      else
        "#{Rails.configuration.logos_domain}/images/government_logos/#{directory}/64_64/#{image_name}"
      end
    end

  def get_government_type_image_128(image_name)
    if(image_name.nil? || image_name.empty?)
      "#{Rails.configuration.logos_domain}/images/government_type_logos/128_128/not_found.png"
    else
      "#{Rails.configuration.logos_domain}/images/government_type_logos/128_128/#{image_name}"
    end
  end


  def get_product_image_128(image_name)
    if(image_name.nil? || image_name.empty?)
      "#{Rails.configuration.logos_domain}/images/product_logos/128_128/not_found.gif"
    else
      "#{Rails.configuration.logos_domain}/images/product_logos/128_128/#{image_name}"
    end
  end
end
