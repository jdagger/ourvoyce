class Admin::CorporationsController < AdminController

  # GET /corporations
  def index
    @corporations = Corporation.all
  end

  # GET /corporations/1
  def show
    @corporation = Corporation.find(params[:id])
  end

  # GET /corporations/new
  def new
    @corporation = Corporation.new
  end

  # GET /corporations/1/edit
  def edit
    @corporation = Corporation.find(params[:id])
  end

  # POST /corporations
  def create
    @corporation = Corporation.new(params[:corporation])

      if @corporation.save
        redirect_to(admin_corporation_path(@corporation), :notice => 'Corporation was successfully created.')
      else
        render :action => "new"
      end
  end

  # PUT /corporations/1
  def update
    @corporation = Corporation.find(params[:id])

      if @corporation.update_attributes(params[:corporation])
        redirect_to(admin_corporation_path(@corporation), :notice => 'Corporation was successfully updated.')
      else
        render :action => "edit"
      end
  end

  # DELETE /corporations/1
  def destroy
    @corporation = Corporation.find(params[:id])
    @corporation.destroy

	redirect_to(admin_corporations_url)
  end
end
