module ColorHelper
  def color_from_social_score score
    color = 'ffffff'
    if score < 45
      color = 'ff0000'
    elsif score >= 45 && score <= 55
      color = 'F88017'
    else
      color = '00ff00'
    end
  end
end
