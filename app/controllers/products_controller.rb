class ProductsController < ApplicationController
	skip_before_filter :basic_authentication, :only => [:lookup]
	skip_before_filter :authorize, :only => [:lookup]

	def index
		#@presenter = ProductsIndexPresenter.new(nil)
		#@presenter.load(session[:user_id], params[:offset], 15, product_change_support_path)
		#@presenter

		page_size = 15
		page = [params[:page].to_i, 1].max

		#Set up search options
		search_options = {
			:select => %w{products.id name description logo social_score participation_rate },
			:filters => {},
			:sorting => {},
			:limit => page_size,
			:offset => (page - 1) * page_size
		}

		user = User.find(self.user_id)
		search_options[:select] << "product_supports.updated_at"
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

		products = Product.new
		products.build_search search_options

		#Set up the presenter
		@presenter = ProductsIndexPresenter.new

		#Paging
		@presenter.paging = PagingHelper::PagingData.new
		@presenter.paging.total_pages = (products.get_search_total_records.to_f / page_size).ceil
		@presenter.paging.current_page = page

		#Build paging links
		(1..@presenter.paging.total_pages).each do |count|
			link = {:link_url => url_for(:controller => "products", :action => 'index', :page => count, :sort => params[:sort], :filter => params[:filter]), :page => count}
			@presenter.paging.links << link
		end

		@presenter.products = products.get_search_results

	end
=begin
	def change_support
		ProductSupport.delete_all(:product_id => params[:item_id], :user_id => session[:user_id])

		if (!params[:thumbs_up].nil?)
			product = ProductSupport.new(:product_id => params[:item_id], :user_id => session[:user_id], :support_type => 1)
			product.save
		elsif (!params[:thumbs_down].nil?)
			product = ProductSupport.new(:product_id => params[:item_id], :user_id => session[:user_id], :support_type => 0)
			product.save
		end

		redirect_to request.referrer
	end
=end

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
		#respond_to do |format|
		#	format.html {redirect_to request.referrer}
		#	format.json { render :json => {'result' => true}}
		#end
	end

	def lookup
		require 'xmlrpc/client'


		rpc_key = 'f14c286343c865fe334bb85a86360045720da468'
		server = XMLRPC::Client.new2('http://www.upcdatabase.com/xmlrpc')

		code = params[:upc]
		type = code.length == 13 ? "ean" : "upc"

		upc_code = code.length == 13 ? "" : code
		ean_code = code.length == 13 ? code : ""

		#Try to find the record in the database
		record = Product.where(["#{type} = ?", code])


		@status = ""
		if record.count == 0
			#Record not in database, so try to find in upcdatabase
			begin
				rpc_response = server.call("lookup", {'rpc_key' => rpc_key, type => code})
				rpc_status = rpc_response['status']
				rpc_found = rpc_response['found']
				rpc_message = rpc_response['message']

				#record found
				if rpc_status.eql?("success") && rpc_found
					rpc_description = rpc_response['description']
					rpc_upc = rpc_response['upc']
					rpc_ean = rpc_response['ean']
					Product.create(:name => rpc_description, :upc => rpc_upc, :ean => rpc_ean, :found => "true", :status => rpc_status, :message => rpc_message, :source => "upcdatabase")
					@status = "Record found in UPCDatabase.  (#{rpc_description})"
				else
					Product.create(:upc => upc_code, :ean => ean_code, :found => "false", :status => rpc_status, :message => rpc_message)
					@status = "Record not found in UPCDatabase. Status: #{rpc_status}, Message: #{rpc_message}"
				end

			rescue XMLRPC::FaultException => e
				@status = "Error: #{e.faultCode} #{e.faultString}"
			end
		else
			redirect_to(admin_product_path(record[0]), :notice => 'Record already in database.')
			#@status = "Record already in database."
		end
	end
end
