class AccountController < ApplicationController
	skip_before_filter :authorize, :only => [:new, :create]

	def new
		@user = User.new
	end

	def create
    @user = User.new(:username => params[:username], :password => params[:password], :zip_code => params[:zip_code], :birth_year => params[:birth_year], :email => params[:email])
		if @user.save
			redirect_to myvoyce_path
		else
			render :action => "new"
		end
	end
end
