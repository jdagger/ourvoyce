class MyvoyceController < ApplicationController

  skip_before_filter :authorize, :only => [:new, :create, :authenticate]

  def index
    if params[:sort].blank?
      params[:sort] = 'name_asc'
    end

    @presenter = ProductsIndexPresenter.new

    page_size = 15
    current_page = [params[:page].to_i, 1].max

    search_params = {}
    search_params[:user_id] = self.user_id

    begin
      search_params[:sort_name], search_params[:sort_direction] = params[:sort].split('_')
    rescue
    end

    #If no filter was supplied, specify all records should be returned
    if params[:filter].empty?
      params[:filter] = 'vote=all'
    else
      #filters have form 'key1=value1;key2=value2'
      params[:filter].split(';').each do |part|
        key_value = part.split('=')
        if key_value.length == 2
          key = key_value[0].downcase
          value = key_value[1].strip
          case key
          when 'vote'
            search_params[:vote] = value
          end
        end
      end
    end

    records = Product.do_search search_params

    #Paging
    @presenter.paging = PagingHelper::PagingData.new
    @presenter.paging.total_pages = (records.count.to_f / page_size).ceil
    @presenter.paging.current_page = current_page

    #Build paging links
    (1..@presenter.paging.total_pages).each do |count|
      link = {:link_url => url_for(:controller => "myvoyce", :action => 'index', :page => count, :sort => params[:sort], :filter => params[:filter]), :page => count}
      @presenter.paging.links << link
    end

    records = records.offset((current_page - 1) * page_size).limit(page_size)

    @presenter.products = records


  end

  def logout
    session[:user_id] = nil
    redirect_to :action => :new, :notice => 'Logged out'
  end

  def new
    if !session[:user_id].nil?
      redirect_to :action => :index
      return
    end
    @create_user = User.new
    @authenticate_user = User.new
  end

  def create
    @user = User.new(:username => params[:username], :password => params[:password], :zip_code => params[:zip_code], :birth_year => params[:birth_year], :email => params[:email])
    if @user.save
      session[:user_id] = @user.id
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def authenticate
    @create_user = User.new
    @authenticate_user = User.new(:username => params[:username], :password => params[:password])
    if user = User.authenticate(@authenticate_user.username, @authenticate_user.password)
      session[:user_id] = user.id
      redirect_to :action => :index
    else
      flash[:login_message] = "Invalid username or password."
      render :action => :new
    end
  end

end
