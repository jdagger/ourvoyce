class Admin::MediasController < AdminController

  # GET /medias
  def index
    @medias = Media.find(:all, :order => [:media_type_id, :parent_media_id, :name])
  end

  # GET /medias/1
  def show
    @media = Media.find(params[:id])
  end

  # GET /medias/new
  def new
    @media = Media.new
  end

  # GET /medias/1/edit
  def edit
    @media = Media.find(params[:id])
  end

  # POST /medias
  def create
    @media = Media.new(params[:media])

      if @media.save
        redirect_to(admin_media_path(@media), :notice => 'Media was successfully created.')
      else
        render :action => "new"
      end
  end

  # PUT /medias/1
  def update
    @media = Media.find(params[:id])

      if @media.update_attributes(params[:media])
        redirect_to(admin_media_path(@media), :notice => 'Media was successfully updated.')
      else
        render :action => "edit"
      end
  end

  # DELETE /medias/1
  def destroy
    @media = Media.find(params[:id])
    @media.destroy

	redirect_to(admin_medias_url)
  end
end
