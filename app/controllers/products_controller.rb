class ProductsController < ApplicationController
	def vote
		support_type = -1

		if (!params[:thumbs_up].nil?)
			support_type = 1
		elsif (!params[:thumbs_down].nil?)
			support_type = 0
		elsif (!params[:neutral].nil?)
			support_type = 2
    elsif (!params[:clear].nil?)
      support_type = -1
		end

		ProductSupport.change_support(params[:item_id], @current_user.id, support_type)

    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.json { render :json => { :result => 'success' }}
    end
	end
end
