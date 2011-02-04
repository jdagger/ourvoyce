module ApplicationHelper
  include ImageHelper
  include VoteCssHelper

  def user_count
    User.all.count
  end

  def highlight_missing_cell
    "<div class='highlight_missing'>&nbsp;</div>".html_safe
  end

  def highlight_found_cell
    "<div class='highlight_found'>&nbsp;</div>".html_safe
  end

  def highlight_existence(val)
    val.blank? ? highlight_missing_cell : highlight_found_cell
  end

  def highlight_or_value(val)
    val.blank? ? highlight_missing_cell : val
  end

  def highlight_or_link(val)
    if val.blank?
      highlight_missing_cell
    else
      link_to "Link", val, :target => '_blank'
    end
  end
end
