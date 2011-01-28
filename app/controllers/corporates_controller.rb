class CorporatesController < ApplicationController
	def index
		page_size = 15
		page = [params[:page].to_i, 1].max
    
		#Set up search options
		search_options = {
			:select => %w{corporations.id name logo social_score participation_rate revenue profit },
			:filters => {},
			:sorting => {},
			:limit => page_size,
			:offset => (page - 1) * page_size
		}

		user = User.find(self.user_id)
		search_options[:select] << "corporation_supports.updated_at"
		search_options[:include_user_support] = user.id

		#Sorting
		if !params[:sort].nil?
			sort_params = params[:sort].split(/_/)
			search_options[:sorting][:sort_name] = sort_params[0]
			search_options[:sorting][:sort_direction] = sort_params[1]

		end

		if !params[:filter].nil?
			search_options[:filters][:vote] = params[:filter]
		end

		corporations = Corporation.new
		corporations.build_search search_options

		#Set up the presenter
		@presenter = CorporationsIndexPresenter.new

		#Paging
		@presenter.paging = PagingHelper::PagingData.new
		@presenter.paging.total_pages = (corporations.get_search_total_records.to_f / page_size).ceil
		@presenter.paging.current_page = page

		#Build paging links
		(1..@presenter.paging.total_pages).each do |count|
			link = {:link_url => url_for(:controller => "corporates", :action => 'index', :page => count, :sort => params[:sort], :filter => params[:filter]), :page => count}
			@presenter.paging.links << link
		end

		@presenter.corporations = corporations.get_search_results

	end

	def vote
		support_type = -1

		if (!params[:thumbs_up].nil?)
			support_type = 1
		elsif (!params[:thumbs_down].nil?)
			support_type = 0
		elsif (!params[:neutral].nil?)
			support_type = 2
		end

		CorporationSupport.change_support(params[:item_id], session[:user_id], support_type)

		redirect_to request.referrer
		#respond_to do |format|
		#	format.html {redirect_to request.referrer}
		#	format.json { render :json => {'result' => true}}
		#end
	end

end
