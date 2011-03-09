class HomeController < ApplicationController

  skip_before_filter :require_user, :only => [:index]

	def index
    @user_session = UserSession.new
    render :layout => false
	end
end
