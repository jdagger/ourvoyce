class CorporatesController < ApplicationController
  skip_before_filter :require_user, :only => :index

  def index
    #Check if form was submitted with a new text filter
    if !params[:search_filter].blank?
      redirect_to :filter => "text=#{params[:search_filter]}", :sort => params[:sort]
    end

    if params[:sort].blank?
      params[:sort] = 'revenue_desc'
    end

    #Set up the presenter
    @presenter = CorporationsIndexPresenter.new

    page_size = Rails.configuration.default_page_size
    current_page = [params[:page].to_i, 1].max

    search_params = {}
    if ! current_user.nil?
      search_params[:user_id] = current_user.id
      @current_user = current_user
    end

    search_params[:sort] = params[:sort]

    #If no filter was supplied, specify all records should be returned
    if params[:filter].blank?
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

    @presenter.corporations = records.to_a

    @default_map = {:id => '', :title => '', :website => '', :wikipedia => ''}
    if @presenter.corporations.count > 0
      current = @presenter.corporations[0]
      @default_map[:id] = current.id
      @default_map[:title] = current.name
      @default_map[:website] = current.corporate_url
      @default_map[:wikipedia] = current.wikipedia_url
    end
  end


  def vote
    support_type = -1

    if (!params[:thumbs_up].nil?)
      support_type = 1
    elsif (!params[:thumbs_down].nil?)
      support_type = 0
    elsif (!params[:neutral].nil?)
      support_type = 2
    elsif (!params[:clear].nil?)
      support_type = -1
    end

    CorporationSupport.change_support(params[:item_id], current_user.id, support_type)

    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.json { render :json => { :result => 'success' }}
    end
  end
end
