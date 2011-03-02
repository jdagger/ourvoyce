class HomeController < ApplicationController
  skip_before_filter :authorize
	def index
    if !session[:user_id].nil?
      redirect_to :controller => :myvoyce, :action => :index
      return
    end
    @authenticate_user = User.new
    render :layout => false
	end

  def authenticate
    @create_user = User.new
    @authenticate_user = User.new(:username => params[:username], :password => params[:password])
    if user = User.authenticate(@authenticate_user.username, @authenticate_user.password)
      session[:user_id] = user.id
      redirect_to :controller => :myvoyce, :action => :index
    else
      flash[:notice] = "Invalid username or password."
      render :action => :index, :layout => false
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = 'You have been logged out.'
    redirect_to :action => :index
  end

end
