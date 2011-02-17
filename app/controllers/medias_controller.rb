class MediasController < ApplicationController
  #Url: /media/:media_type/:network
  def index

    @presenter = MediaPresenter.new

    populate_media_types
    populate_networks
    populate_shows
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

    MediaSupport.change_support(params[:item_id].to_i, session[:user_id].to_i, support_type)

    redirect_to request.referrer
  end

  private
  def populate_media_types
    #Check if media type was selected
    if ! params.key? :media_type
      #Media type not selected, so provide default list of media types
      @presenter.media_types = MediaType.where(:level => 1).order(:display_order)
    else #media type selected

      #Load the media type,
      type = MediaType.where(:name => params[:media_type]).first

      #Validate selected media type
      if(type.nil?) #type could not be loaded
        redirect_to :media_type => nil, :network => nil
        return
      elsif type.level != 1 #type is not top level
        redirect_to :media_type => nil, :network => nil
        return
      end

      # Add the selected media type to the list
      @presenter.media_types << type  
    end
  end




  def populate_networks
    #If a media_type has not been selected, return
    if @presenter.media_types.count != 1
      return
    end

    media_type = @presenter.media_types[0]

    #Check if magazine or newspaper.  If so, there is no network, so return
    if [1, 2].include?(media_type.id)
      params[:network]  = 'all'
      return
    end


    if params[:network].blank?
      #Network not yet selected, so display a list of networks for the media type
      search_options = {}
      search_options[:user_id] = self.user_id
      search_options[:media_type_id] = media_type.id
      @presenter.networks = Media.do_search search_options
    else
      #Network specified, so try to load it
      network = Media.where(:name => params[:network]).first

      #Validate network could be loaded
      if(network.nil?) #network could not be found
        redirect_to :media_type => nil, :network => nil
        return
      elsif(! [3,4].include?(network.media_type_id.to_i)) #type must be radio or television
        redirect_to :media_type => nil, :network => nil
        return
      end

      @presenter.networks << network
    end
  end





  def populate_shows
    #Verify a media type has been selected
    if @presenter.media_types.count != 1
      return
    end

    media_type = @presenter.media_types[0]

    
    search_options = {}
    search_options[:user_id] = self.user_id

    if params[:sort].blank? 
      params[:sort] = 'name_asc'
      search_options[:sort] = 'name_asc'
    else
      search_options[:sort] = params[:sort]
    end

    if params[:filter].blank?
      params[:filter] = 'all'
    else
      search_options[:vote] = params[:filter]
    end

    do_search = false

    if [1, 2].include? media_type.id
      #If the selected media_type is magazine or newspaper, load the shows
      search_options[:media_type_id] = media_type.id
      do_search = true
    elsif @presenter.networks.count == 1
      #Otherwise, make sure a network was selected
      search_options[:parent_media_id] = @presenter.networks[0].id
      do_search = true
    end

    if do_search
      @presenter.force_display_shows = true #Make sure the shows section is displayed, even if a filter eliminates all results
      records = Media.do_search search_options
      page_size = 28
      populate_paging records, page_size
      records = records.offset((@paging.current_page - 1) * page_size).limit(page_size)
      @presenter.shows = records
    end
  end

  def populate_paging records, page_size
    current_page = [params[:page].to_i, 1].max
    @paging = PagingHelper::PagingData.new
    @paging.total_pages = (records.count.to_f / page_size).ceil
    @paging.current_page = current_page

    #Build paging links
    (1..@paging.total_pages).each do |count|
      link = {:link_url => url_for(:controller => "medias", :action => 'index', :media_type => params[:media_type], :network => params[:network], :page => count, :sort => params[:sort], :filter => params[:filter]), :page => count}
      @paging.links << link
    end
  end
end
