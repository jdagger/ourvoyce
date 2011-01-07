class MediasController < ApplicationController
	def index
    @presenter = MediaPresenter.new
    if(!params[:type].nil?) #type selected
      type = MediaType.where(:name => params[:type]).first
      if(type.nil?) #type could not be loaded
        redirect_to :type => nil, :network => nil
        return
      elsif type.level != 1 #type is not top level
        redirect_to :type => nil, :network => nil
        return
      end
      @presenter.media_types << type

      if(!params[:network].nil?) #network is specified
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
        @presenter.third_level = Media.where(:parent_media_id => network.id)
      else
        @presenter.second_level = Media.where(:media_type_id => type.id).order(:name)
      end


    else #top level
      @presenter.media_types = MediaType.where(:level => 1).order(:display_order)
    end
	end
end
