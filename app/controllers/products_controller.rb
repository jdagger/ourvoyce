class ProductsController < ApplicationController
  skip_before_filter :require_user, :only => [:category]

  def lookup
    redirect_to :controller => :users, :action => :show, :filter => 'vote=all', :sort => 'votedate_desc', :page => 1, :barcode => params[:id]
  end

  def category
    redirect_to :controller => :users, :action => :show, :filter => "category=#{params[:id]}"
  end

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

		#ProductSupport.change_support(params[:item_id], @current_user.id, support_type)
    ps = ProductSupport.new
    ps.remote_ip = request.remote_ip
		ps.change_support(params[:item_id], @current_user.id, support_type)

    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.json { render :json => { :result => 'success' }}
    end
	end
end
