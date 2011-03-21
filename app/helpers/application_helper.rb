module ApplicationHelper

  include ImageHelper
  include VoteCssHelper

  def user_count
    User.count
  end

  def table_sort_header_link params = {}
    sort_column = ''
    sort_direction = ''
    direction = 'desc'
    sort_column, sort_direction = request[:sort].downcase.split('_') rescue ['','']
    #Check if this column is the current sort column
    if sort_column == params[:sort_column]
      #If selected column, display the appropriate arrow
      if sort_direction == 'asc'
        text = "#{params[:header]} <img src='/images/sort_arrow_up.gif' />"
        direction = 'desc' #Set the direction for clicking on the header link
      else
        text = "#{params[:header]} <img src='/images/sort_arrow_down.gif' />"
        direction = 'asc' #Set the direction for clicking on the header link
      end
    else
      #not selected sort column, so just display the text
      text = "#{params[:header]}"

      #Sort not specified, so use the default initial sort, if specified
      if params.key? :default_direction
        direction = params[:default_direction]
      end
    end

    params[:link_params][:sort] = "#{params[:sort_column]}_#{direction}"
    "#{link_to(text.html_safe, params[:link_params])}".html_safe #the div whitespace is messing with table headers for SS/PR
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
  
  def filter_is_selected(filter, params)
    if filter == params[:filter]
      return "selected"
    else
      return ""
    end
  end
end
