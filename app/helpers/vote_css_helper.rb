module VoteCssHelper
  def thumbs_up_support_class(support_type)
    if support_type.nil?
      return "thumbs-up"
    end
    case support_type.to_i
      when 0 #thumbs_down
        return "thumbs-up-not-selected"
      when 2 #neutral
        return "thumbs-up-not-selected"
      when 1 #thumbs_up
        return "thumbs-up-selected"
      else
        return "thumbs-up"
    end
  end

  def thumbs_down_support_class(support_type)
    if support_type.nil?
      return "thumbs-down"
    end

    case support_type.to_i
      when 0 #thumbs_down
        return "thumbs-down-selected"
      when 1 #thumbs_up
        return "thumbs-down-not-selected"
      when 2 #neutral
        return "thumbs-down-not-selected"
      else
        return "thumbs-down"
    end
  end

  def neutral_support_class(support_type)
    if support_type.nil?
      return "neutral"
    end

    case support_type.to_i
      when 0 #thumbs_down
        return "neutral-not-selected"
      when 1 #thumbs_up
        return "neutral-not-selected"
      when 2 #neutral
        return "neutral-selected"
      else
        return "neutral"
    end
  end
end
