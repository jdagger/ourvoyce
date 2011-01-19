class MyvoyceController < ApplicationController
  
  #TODO THIS FORM NEEDS MAJOR REFACTORING TO STREAMLINE FLOW, CLEANUP LOGIC

  skip_before_filter :authorize, :only => [:new_account, :create_account, :authenticate_user]

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
      link = {:link_url => url_for(:controller => "myvoyce", :action => 'index', :page => count, :sort => params[:sort], :filter => params[:filter]), :page => count}
      @presenter.paging.links << link
    end

    @presenter.products = products.get_search_results

  end
  
  def logout
    session[:user_id] = nil
    redirect_to account_path, :notice => 'Logged out'
  end

  def new_account
    @create_user = User.new
    @authenticate_user = User.new
  end

  def create_account
    @user = User.new(:username => params[:username], :password => params[:password], :zip_code => params[:zip_code], :birth_year => params[:birth_year], :email => params[:email])
    if @user.save
      session[:user_id] = @user.id
      redirect_to myvoyce_path
    else
      render :action => "new_account"
    end
  end

  def authenticate_user
    @create_user = User.new
    @authenticate_user = User.new(:username => params[:username], :password => params[:password])
    if user = User.authenticate(@authenticate_user.username, @authenticate_user.password)
      session[:user_id] = user.id
      redirect_to myvoyce_path
    else
      flash[:login_message] = "Invalid username or password."
      render :action => :new_account
    end
  end

end
