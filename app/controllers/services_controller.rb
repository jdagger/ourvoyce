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
    @states = Corporation.map_all params[:corporation_id]
    render :template => 'services/corporate/national_map'
  end

  def corporate_map_state
    @zips = Corporation.map_state params[:corporation_id], params[:state]
    render :template => 'services/corporate/state_dots'
  end

  def corporate_age_all
    @results = Corporation.age_all params[:corporation_id]
    render :template => 'services/corporate/age'
  end

  def corporate_age_state
    @results = Corporation.age_state params[:corporation_id], params[:state]
    render :template => 'services/corporate/age'
  end


end
