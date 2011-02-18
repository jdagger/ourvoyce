class ServicesController < ApplicationController
  skip_before_filter :authorize, :basic_authentication
	#skip_before_filter :authorize, :only => [:check_unique_user, :xml, :corporate]
	#skip_before_filter :basic_authentication, :only => [:xml, :corporate]
  
	protect_from_forgery :except => [:xml, :corporate]

	def check_unique_user
		username = params[:username]
		render :json => {'username' => username, 'unique'=> !User.exists?(:username => username)}
	end


	def xml
		handler = ServiceHandler.new
		response = handler.handle_request(params[:Request])
		render :xml => response.to_xml({:skip_instruct => false, :root => "Response", :skip_types => true})
	end


  def corporate_map_all
    @states = Corporation.new.map_all params[:corporation_id]
    render :template => 'services/map/national'
  end

  def corporate_map_state
    @zips = Corporation.new.map_state params[:corporation_id], params[:state]
    render :template => 'services/map/state'
  end

  def corporate_age_all
    @results = Corporation.new.age_all params[:corporation_id]
    render :template => 'services/graph/age'
  end

  def corporate_age_state
    @results = Corporation.new.age_state params[:corporation_id], params[:state]
    render :template => 'services/graph/age'
  end

  def ourvoyce_age_all
    @results = User.new.age_all 
    render :template => 'services/graph/age'
  end

  def ourvoyce_age_state
    @results = User.new.age_state params[:state]
    render :template => 'services/graph/age'
  end

  def ourvoyce_map_all
    @states = User.new.map_all
    render :template => 'services/map/national'
  end

  def ourvoyce_map_state
    @zips = User.new.map_state params[:state]
    render :template => 'services/map/state'
  end

  def government_age_all
    @results = Government.new.age_all params[:government_id]
    render :template => 'services/graph/age'
  end

  def government_age_state
    @results = Government.new.age_state params[:government_id], params[:state]
    render :template => 'services/graph/age'
  end

  def government_map_all
    @states = Government.new.map_all params[:government_id]
    render :template => 'services/map/national'
  end

  def government_map_state
    @zips = Government.new.map_state params[:government_id], params[:state]
    render :template => 'services/map/state'
  end

  def legislative_state_age_all
    @results = Government.new.legislative_state_age_all params[:state_id]
    render :template => 'services/graph/age'
  end

  def legislative_state_age_state
    @results = Government.new.legislative_state_age_state params[:state_id], params[:state]
    render :template => 'services/graph/age'
  end

  def legislative_state_map_all
    @states = Government.new.legislative_state_map_all params[:state_id]
    render :template => 'services/map/national'
  end

  def legislative_state_map_state
    @zips = Government.new.legislative_state_map_state params[:state_id], params[:state]
    render :template => 'services/map/state'
  end

  def media_age_all
    @results = Media.new.age_all params[:media_id]
    render :template => 'services/graph/age'
  end

  def media_age_state
    @results = Media.new.age_state params[:media_id], params[:state]
    render :template => 'services/graph/age'
  end

  def media_map_all
    @states = Media.new.map_all params[:media_id]
    render :template => 'services/map/national'
  end

  def media_map_state
    @zips = Media.new.map_state params[:media_id], params[:state]
    render :template => 'services/map/state'
  end

  def media_type_age_all
    @results = Media.new.media_type_age_all params[:media_type_id]
    render :template => 'services/graph/age'
  end

  def media_type_age_state
    @results = Media.new.media_type_age_state params[:media_type_id], params[:state]
    render :template => 'services/graph/age'
  end

  def media_type_map_all
    @states = Media.new.media_type_map_all params[:media_type_id]
    render :template => 'services/map/national'
  end

  def media_type_map_state
    @zips = Media.new.media_type_map_state params[:media_type_id], params[:state]
    render :template => 'services/map/state'
  end

  def network_age_all
    @results = Media.new.network_age_all params[:network_id]
    render :template => 'services/graph/age'
  end

  def network_age_state
    @results = Media.new.network_age_state params[:network_id], params[:state]
    render :template => 'services/graph/age'
  end

  def network_map_all
    @states = Media.new.network_map_all params[:network_id]
    render :template => 'services/map/national'
  end

  def network_map_state
    @zips = Media.new.network_map_state params[:network_id], params[:state]
    render :template => 'services/map/state'
  end
end
