class UsersController < ApplicationController
  skip_before_filter :require_user, :only => [:login, :create, :new, :verify, :request_username]

  ssl_required :new, :create, :update, :edit, :login

  def new
    @new_user = User.new :country_id => 242
    @user_session = UserSession.new
  end

  def create
    @new_user = User.new(params[:user])
    if @new_user.save
      flash[:notice] = "Thank you for signing up!  Please check your email to verify your account before logging in."
      @new_user.deliver_verification_instructions!

      redirect_to :register
    else
      @user_session = UserSession.new #Needed for login portion of screen
      render :action => :new
    end
  end

  def show
    @user = @current_user
    search_params = {}
    search_params[:user_id] = @user.id

    if params[:sort].blank?
      params[:sort] = 'description_asc'
      search_params[:sort] = 'description_asc'
    else
      search_params[:sort] = params[:sort]
    end

    if params[:page].blank?
      params[:page] = 1
    end

    @presenter = ProductsIndexPresenter.new
    @stats = User.new.user_stats @user.id unless fragment_exist?("user_stats_#{@user.id}")

    page_size = Rails.configuration.default_page_size
    current_page = [params[:page].to_i, 1].max



    #If no filter was supplied, specify all records should be returned
    if params[:filter].blank?
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

    #barcode lookup was selected
    if params.key? :lookup_submit
      redirect_to :barcode => params[:barcode_lookup].strip, :filter => params[:filter], :sort => params[:sort], :page => params[:page]
      return
    end


    if ! params[:barcode].blank?
      @show_current_product = true
      product = Product.upc_lookup :upc => params[:barcode]
      if product.nil?
        @product_found = false
      else
        @product_found = true
        support = ProductSupport.where(:user_id => @user.id, :product_id => product.id).first
        @current_product_description = product.description
        @current_product_image = product.logo
        @current_product_id = product.id
        @current_product_support = support.support_type rescue -1
        @current_product_ss = product.social_score
        @current_product_pr = product.participation_rate
      end
    else
      @show_current_product = false
    end


    records = Product.do_search search_params

    #Paging
    @presenter.paging = PagingHelper::PagingData.new
    @presenter.paging.total_pages = (records.count.to_f / page_size).ceil
    @presenter.paging.current_page = current_page

    #Build paging links
    (1..@presenter.paging.total_pages).each do |count|
      link = {:link_url => url_for(:controller => :users, :action => :show, :page => count, :sort => params[:sort], :barcode => params[:barcode], :filter => params[:filter]), :page => count}
      @presenter.paging.links << link
    end

    records = records.offset((current_page - 1) * page_size).limit(page_size)

    @presenter.products = records
  end

  def edit
    @new_user = @current_user
  end

  def update
    @new_user = @current_user # makes our views "cleaner" and more consistent
    if @new_user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to myvoyce_url
    else
      render :action => :edit
    end
  end

  def verify
    if params[:email].blank? && !params[:id].blank?
      @user = User.find_using_perishable_token(params[:id])
      if @user
        @user.verify!
        flash[:notice] = "Thank you for verifying your account. You can now login to your account."
        redirect_to :register
      end
    elsif ! params[:email].blank?
      @user = User.find_by_email params[:email]
      if @user
        @user.deliver_verification_instructions!  
        flash[:notice] = "Check your email for verification details."
        redirect_to :register  
      else  
        flash[:notice] = "No user was found with that email address"  
        render :action => :verify  
      end
    end
  end

  def request_username
    if !params[:email].blank?
      @user = User.find_by_email params[:email]
      if @user
        @user.deliver_username!  
        flash[:notice] = "Check your email for your username."
        redirect_to :register  
      else  
        flash[:notice] = "No user was found with that email address"  
        render :action => :request_username  
      end
    end
  end

  def login
    @user_session = UserSession.new(:login => params[:login], :password => params[:password])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default myvoyce_url
    elsif Rails.application.routes.recognize_path(request.referrer)[:controller] == 'home'
      #This is a temporary conditional to handle the login-only home page
      flash[:notice] = "Unable to login. Make sure you have verified your account."
      redirect_to root_url
    else
      flash[:notice] = "Unable to login. Make sure you have verified your account."
      @new_user = User.new :country_id => 242
      render :action => :new
    end
  end

  def logout
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_url
  end
end
