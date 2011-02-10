class MediasController < ApplicationController
  #Url: /media/:type/:network
	def index
    search_options = {}
    search_options[:user_id] = self.user_id

    @presenter = MediaPresenter.new
    
    if ! params.key? :type
      @presenter.media_types = MediaType.where(:level => 1).order(:display_order)
    else #media type selected
      type = MediaType.where(:name => params[:type]).first  #Load the media type, based on specified name

      #Validate selected media type
      if(type.nil?) #type could not be loaded
        redirect_to :type => nil, :network => nil
        return
      elsif type.level != 1 #type is not top level
        redirect_to :type => nil, :network => nil
        return
      end

      # Add the selected media type to the list
      @presenter.media_types << type  

      if params[:network].nil? #network not specified yet
        if [1,2].include?(type.id.to_i)
          @presenter.second_level_vote = true
        end
        #search_options[:filters][:media_type] = type.id
        search_options[:media_type_id] = type.id
        #medias.build_search search_options
        #@presenter.second_level = medias.get_search_results
        @presenter.second_level = Media.do_search search_options
      else
        network = Media.where(:name => params[:network]).first

        if(network.nil?) #network could not be found
          redirect_to :type => nil, :network => nil
          return
        elsif(! [3,4].include?(network.media_type_id.to_i)) #type must support second level
          redirect_to :type => nil, :network => nil
          return
        end

        @presenter.second_level << network


        #load shows for the network
        #search_options[:filters][:parent_id] = network.id
        search_options[:parent_media_id] = network.id
        #medias.build_search search_options
        #@presenter.third_level = medias.get_search_results
        @presenter.third_level = Media.do_search search_options
      end
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
    end

    MediaSupport.change_support(params[:item_id].to_i, session[:user_id].to_i, support_type)

    redirect_to request.referrer
  end
end
