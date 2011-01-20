class ApplicationController < ActionController::Base
	before_filter :basic_authentication
	before_filter :authorize

	protect_from_forgery

	protected
	def authorize
		begin
			User.find(session[:user_id])
		rescue
			redirect_to myvoyce_account_path
		end
	end
	#To Skip - skip_before_filter :authorize, only => [:create, :update, :destroy]

	def is_authenticated?
		session[:user_id].nil?
	end

	def user_id
		session[:user_id]
	end

	def basic_authentication
		authenticate_or_request_with_http_basic do |username, password|
			username=='ourvoyce' && password=='elab321'
		end
	end
end
