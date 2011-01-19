class ProductsController < ApplicationController
	def vote
		support_type = -1

		if (!params[:thumbs_up].nil?)
			support_type = 1
		elsif (!params[:thumbs_down].nil?)
			support_type = 0
		elsif (!params[:neutral].nil?)
			support_type = 2
		end

		ProductSupport.change_support(params[:item_id], session[:user_id], support_type)

		redirect_to request.referrer
	end
end
