class Admin::UsersController < AdminController
	# GET admin/users
	def index
    if ! params[:filter_username].blank?
      redirect_to :filter => "#{params[:username]}"
    end

    if params[:filter].blank?
      @users = User.where("1=1")
    else
      @users = User.where('login = ? OR email = ?', params[:filter], params[:filter])
    end
    @user_count = @users.count

    page_size = 100 
    page = [params[:page].to_i, 1].max
    @users = @users.offset((page - 1) * page_size).limit(page_size)

    @paging = PagingHelper::PagingData.new
    @paging.total_pages = (@user_count.to_f / page_size).ceil
    @paging.current_page = page
    (1..@paging.total_pages).each do |count|
      link = {:link_url => url_for(:controller => "admin/users", :action => 'index', :page => count), :page => count}
      @paging.links << link
    end
	end

	# GET /users/1
	def show
		@user = User.find(params[:id])
	end

	# GET admin/users/new
	def new
		@user = User.new
	end

	# POST /users
	def create
		@user = User.new(params[:user])
		if @user.save
			redirect_to(admin_user_path(@user), :notice => 'User was successfully created.')
		else
			render :action => "new"
		end
	end

	# GET /users/1/edit
	def edit
		@user = User.find(params[:id])
	end

	# PUT /users/1
	def update
		@user = User.find(params[:id])

		if @user.update_attributes(params[:user])
			redirect_to(admin_user_path(@user), :notice => 'User was successfully updated.')
		else
			render :action => "edit"
		end
	end

	# DELETE /users/1
	def destroy
		@user = User.find(params[:id])
		@user.destroy

		redirect_to(admin_users_url)
	end
end
