class Admin::ProductsController < ApplicationController
	skip_before_filter :basic_authentication, :only => [:show]
	skip_before_filter :authorize, :only => [:show]

	def index
		page_size = 20
		page = [params[:page].to_i, 1].max
		@presenter = AdminProductsPresenter.new
		@presenter.products = Product.find(:all, :offset => (page - 1) * page_size, :limit => page_size, :order => "name asc")

		@product_count = Product.all.count
		@presenter.paging.total_pages = (@product_count / page_size).ceil
		@presenter.paging.current_page = page
		(1..@presenter.paging.total_pages).each do |count|
			link = {:link_url => url_for(:controller => "admin/products", :action => 'index', :page => count, :sort => params[:sort]), :page => count}
			@presenter.paging.links << link
		end
	end


	def new
		@product = Product.new;
	end


	def create
		@product = Product.new(params[:product])
		if @product.save
			redirect_to(admin_product_path(@product), :notice => 'Post was successfully created.')
		else
			render :action => "new"
		end
	end


	def show
		@product = Product.find(params[:id])
	end


	def edit
		@product = Product.find(params[:id])
	end


	def update
		 @product = Product.find(params[:id]) 
		 if @product.update_attributes(params[:product])
				 redirect_to(admin_product_path(@product), :notice => 'Product was successfully updated.')
		 else
			 render :action => "edit"
		 end
	 end


	def destroy 
		@product = Product.find(params[:id])
		@product.destroy

		redirect_to(admin_products_path)
	end
end
