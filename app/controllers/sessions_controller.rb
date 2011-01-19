class SessionsController < ApplicationController
	skip_before_filter :authorize, :only => [:new, :create]

  def new
	  @presenter = LoginPresenter.new
  end

  def create
	  @presenter = LoginPresenter.new(params)
	  if user = User.authenticate(params[:username], params[:password])
		  session[:user_id] = user.id
		  redirect_to myvoyce_path
	  else
		  flash[:login_message] = "Invalid username or password."
		  render :new
	  end
  end

  def destroy
	  session[:user_id] = nil
	  redirect_to account_path, :notice => 'Logged out'
  end

end
