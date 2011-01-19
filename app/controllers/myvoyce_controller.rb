class MyvoyceController < ApplicationController
  
  #TODO THIS FORM NEEDS MAJOR REFACTORING TO STREAMLINE FLOW, CLEANUP LOGIC

  skip_before_filter :authorize, :only => [:new_account, :create_account, :authenticate_user]

  def index
  end
  
  def logout
    session[:user_id] = nil
    redirect_to account_path, :notice => 'Logged out'
  end

  def new_account
    @create_user = User.new
    @authenticate_user = User.new
  end

  def create_account
    @user = User.new(:username => params[:username], :password => params[:password], :zip_code => params[:zip_code], :birth_year => params[:birth_year], :email => params[:email])
    if @user.save
      session[:user_id] = @user.id
      redirect_to myvoyce_path
    else
      render :action => "new_account"
    end
  end

  def authenticate_user
    @create_user = User.new
    @authenticate_user = User.new(:username => params[:username], :password => params[:password])
    if user = User.authenticate(@authenticate_user.username, @authenticate_user.password)
      session[:user_id] = user.id
      redirect_to myvoyce_path
    else
      flash[:login_message] = "Invalid username or password."
      render :action => :new_account
    end
  end

end
