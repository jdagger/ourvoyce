class ServicesController < ApplicationController

	skip_before_filter :authorize, :only => [:check_unique_user, :xml, :corporate]
	skip_before_filter :basic_authentication, :only => [:xml, :corporate]
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

  def corporate
    result = Corporation.stats(params[:corporation_id], params[:state])
    #render :xml => result.to_xml(:root => "states")
    render :xml => result
  end
end
