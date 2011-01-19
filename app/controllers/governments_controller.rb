class GovernmentsController < ApplicationController
	def index
		redirect_to :action => :executive
	end

	def executive
		user = User.find(self.user_id)

		#Set up search options
		search_options = {
			:select => %w{governments.id first_name last_name title government_type_id logo social_score participation_rate},
			:include_user_support => user.id,
			:filters => {:government_type => 'executive'},
			:sorting => {},
		}

		#Sorting
		#if !params[:sort].nil?
		#	sort_params = params[:sort].split(/_/)
		#	search_options[:sorting][:sort_name] = sort_params[0]
		#	search_options[:sorting][:sort_direction] = sort_params[1]
#
#		end

#		if !params[:filter].nil?
#			search_options[:filters][:vote] = params[:filter]
#		end

		#corporations = Corporation.new
		#corporations.build_search search_options
		governments = Government.new
		governments.build_search search_options

		#Set up the presenter
		@presenter = ExecutivePresenter.new

		@presenter.executives = governments.get_search_results
	end

	def legislative
		if(params[:state].nil?) #State not defined, so display list of states
			@presenter = LegislativeStatePresenter.new
      @presenter.states = State.find(:all, :order => "name asc")
			render 'governments/legislative_states'
    else
      state = State.where(:abbreviation => params[:state]).first
      if state.nil?
        redirect_to :action => :legislative, :state => nil
        return
      end


			@presenter = LegislativePresenter.new
      user = User.find(self.user_id)

      #Set up search options
      search_options = {
          :select => %w{governments.id first_name last_name title government_type_id chamber_id district logo social_score participation_rate},
          :include_user_support => user.id,
          :filters => {:government_type => 'legislative', :state => state.id},
          :sorting => {:default_sort_order => "last_name", :name_column => "last_name"}
      }
      governments = Government.new
      governments.build_search search_options

      results = governments.get_search_results
      results.each do |leg|
        if leg.chamber_id == 1
          @presenter.representatives << leg
        else
          @presenter.senators << leg
        end
      end
			render 'governments/legislative'
		end

	end

	def agency
		user = User.find(self.user_id)

		#Set up search options
		search_options = {
			:select => %w{governments.id name logo social_score participation_rate},
			:include_user_support => user.id,
			:filters => {:government_type => 'agency'},
			:sorting => {},
		}

		governments = Government.new
		governments.build_search search_options

		@presenter = AgencyPresenter.new
		@presenter.agencies = governments.get_search_results

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

		GovernmentSupport.change_support(params[:item_id], session[:user_id], support_type)

		redirect_to request.referrer
		#respond_to do |format|
		#	format.html {redirect_to request.referrer}
		#	format.json { render :json => {'result' => true}}
		#end
	end
end
