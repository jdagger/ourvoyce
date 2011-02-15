class GovernmentsController < ApplicationController
  def index
    redirect_to :action => :executive
  end

  def executive
    search_options = {}
    search_options[:user_id] = self.user_id
    search_options[:branch] = 'executive' 
    search_options[:sort] = 'default_asc'

    @presenter = ExecutivePresenter.new
    @presenter.executives = Government.do_search search_options
  end

  def legislative
    #Check if a state was selected.  
    #If state not selected, display list of states.  
    #Otherwise, display list of legislatives from the state
    if ! params.key? :state
      @presenter = LegislativeStatePresenter.new
      @presenter.states = State.find(:all, 
                                     :select => ["states.name as name", "states.logo as logo", "states.abbreviation as abbreviation", "legislative_states.social_score as social_score", "legislative_states.participation_rate as participation_rate"],
                                     :joins => ["left outer join legislative_states on legislative_states.state_id = states.id"],
                                     :order => "states.name asc"
                                    )
      render 'governments/legislative_states'
    else
      state = State.where(:abbreviation => params[:state]).first

      #Verify the state could be loaded
      if state.nil?
        redirect_to :action => :legislative, :state => nil
        return
      end


      @presenter = LegislativePresenter.new
      search_options = {}

      search_options[:user_id] = self.user_id
      search_options[:branch] = 'legislative'
      search_options[:state] = state.id

      results = Government.do_search search_options
      results.each do |leg|
        if leg.chamber_id == 1
          @presenter.representatives << leg
        else
          @presenter.senators << leg
        end
      end
      render 'governments/legislative'
    end
  end

  def agency

    page_size = 15
    current_page = [params[:page].to_i, 1].max

    @presenter = AgencyPresenter.new
    #Check if form was submitted with a new text filter
    if !params[:search_filter].blank?
      redirect_to :filter => "text=#{params[:search_filter]}", :sort => params[:sort]
    end

    if params[:sort].blank?
      params[:sort] = 'name_asc'
    end

    search_options = {}
    search_options[:user_id] = self.user_id
    search_options[:branch] = 'agency'
    search_options[:sort] = params[:sort]

    #If no filter was supplied, specify all records should be returned
    if params[:filter].blank?
      params[:filter] = 'vote=all'
    else
      #filters have form 'key1=value1;key2=value2'
      params[:filter].split(';').each do |part|
        key, value = part.downcase.split('=')
        case key
        when 'text'
          @presenter.search_text = value
          search_options[:text] = value
        when 'vote'
          search_options[:vote] = value
        end
      end
    end


    records = Government.do_search search_options

    #Paging
    @presenter.paging = PagingHelper::PagingData.new
    @presenter.paging.total_pages = (records.count.to_f / page_size).ceil
    @presenter.paging.current_page = current_page

    #Build paging links
    (1..@presenter.paging.total_pages).each do |count|
      link = {:link_url => url_for(:action => 'agency', :page => count, :sort => params[:sort], :filter => params[:filter]), :page => count}
      @presenter.paging.links << link
    end

    records = records.offset((current_page - 1) * page_size).limit(page_size)
    @presenter.agencies = records
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

    GovernmentSupport.change_support(params[:item_id], session[:user_id], support_type)

    redirect_to request.referrer
    #respond_to do |format|
    #	format.html {redirect_to request.referrer}
    #	format.json { render :json => {'result' => true}}
    #end
  end
end
