class CorporatesController < ApplicationController

  def index
    #Check if form was submitted with a new text filter
    if !params[:search_filter].blank?
      redirect_to :filter => "text=#{params[:search_filter]}", :sort => params[:sort]
    end

    if params[:sort].blank?
      params[:sort] = 'name_asc'
    end

    #Set up the presenter
    @presenter = CorporationsIndexPresenter.new

    page_size = 15
    current_page = [params[:page].to_i, 1].max

    search_params = {}
    search_params[:user_id] = self.user_id

    begin
    search_params[:sort_name], search_params[:sort_direction] = params[:sort].split('_')
    rescue
    end

    #If no filter was supplied, specify all records should be returned
    if params[:filter].empty?
      params[:filter] = 'vote=all'
    else
      #filters have form 'key1=value1;key2=value2'
      params[:filter].split(';').each do |part|
        key_value = part.split('=')
        if key_value.length == 2
          key = key_value[0].downcase
          value = key_value[1].strip
          case key
          when 'text'
            @presenter.search_text = value
            search_params[:text] = value
          when 'vote'
            search_params[:vote] = value
          end
        end
      end
    end

    records = Corporation.do_search search_params

    #Paging
    @presenter.paging = PagingHelper::PagingData.new
    @presenter.paging.total_pages = (records.count.to_f / page_size).ceil
    @presenter.paging.current_page = current_page

    #Build paging links
    (1..@presenter.paging.total_pages).each do |count|
      link = {:link_url => url_for(:controller => "corporates", :action => 'index', :page => count, :sort => params[:sort], :filter => params[:filter]), :page => count}
      @presenter.paging.links << link
    end

    records = records.offset((current_page - 1) * page_size).limit(page_size)

    @presenter.corporations = records

=begin

    #Set up search options
    search_options = {
      :select => %w{corporations.id name logo social_score participation_rate revenue profit },
      :filters => {},
      :sorting => {},
      :limit => page_size,
      :offset => (page - 1) * page_size
    }

    user = User.find(self.user_id)
    search_options[:select] << "corporation_supports.updated_at"
    search_options[:include_user_support] = user.id

    if params[:sort].empty?
      params[:sort] = 'name_asc'
    end

    #Sorting
    sort_params = params[:sort].split(/_/)
    search_options[:sorting][:sort_name] = sort_params[0]
    search_options[:sorting][:sort_direction] = sort_params[1]

    #If no filter was supplied, specify all records should be returned
    if params[:filter].empty?
      params[:filter] = 'vote=all'
      search_options[:filters][:vote] = 'all'
    else
      #filters have form 'key1=value1;key2=value2'
      params[:filter].split(';').each do |part|
        key_value = part.split('=')
        if key_value.length == 2
          key = key_value[0].downcase
          value = key_value[1].strip
          case key
          when 'text'
            search_options[:filters][:text] = value
            @presenter.search_text = value

          when 'vote'
            search_options[:filters][:vote] = value
          end
        end
      end
    end


    corporations = Corporation.new
    corporations.build_search search_options

    #Paging
    @presenter.paging = PagingHelper::PagingData.new
    @presenter.paging.total_pages = (corporations.get_search_total_records.to_f / page_size).ceil
    @presenter.paging.current_page = page

    #Build paging links
    (1..@presenter.paging.total_pages).each do |count|
      link = {:link_url => url_for(:controller => "corporates", :action => 'index', :offset => count, :sort => params[:sort], :filter => params[:filter]), :page => count}
      @presenter.paging.links << link
    end

    @presenter.corporations = corporations.get_search_results
=end

  end


  def vote
    support_type = -1

    if (!params[:thumbs_up].nil?)
      support_type = 1
    elsif (!params[:thumbs_down].nil?)
      support_type = 0
    elsif (!params[:neutral].nil?)
      support_type = 2
    end

    CorporationSupport.change_support(params[:item_id], session[:user_id], support_type)

    redirect_to request.referrer
    #respond_to do |format|
    #	format.html {redirect_to request.referrer}
    #	format.json { render :json => {'result' => true}}
    #end
  end
end
