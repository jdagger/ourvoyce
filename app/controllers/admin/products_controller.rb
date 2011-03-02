class Admin::ProductsController < AdminController
  skip_before_filter :basic_authentication, :only => [:show]
  skip_before_filter :authorize, :only => [:show]

  def index

    if ! params[:filter_upc].blank?
      redirect_to :filter => "upc=#{params[:upc]}"
    elsif ! params[:filter_text].blank?
      redirect_to :filter => "text=#{params[:text]}"
    end

    @presenter = AdminProductsPresenter.new
    if ! params[:filter].blank?
      case params[:filter].downcase
      when 'default_include'
        @presenter.products = Product.default_include
      when 'pending'
        @presenter.products = Product.pending
      else
        type, filter = params[:filter].split('=')
        case type
        when 'upc'
          @presenter.products = Product.where("upc = ? or ean = ?", filter, filter)
        else
          @presenter.products = Product.search filter
        end
      end
    else
        @presenter.products = Product.where("1=1")
    end
    page_size = 100 
    page = [params[:page].to_i, 1].max
    @presenter.products = @presenter.products.order("name asc") 

    @product_count = @presenter.products.count
    @presenter.products = @presenter.products.offset((page - 1) * page_size).limit(page_size)
    @presenter.paging.total_pages = (@product_count.to_f / page_size).ceil
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
