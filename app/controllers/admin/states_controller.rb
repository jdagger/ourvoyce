class Admin::StatesController < AdminController

  def index
    @states = State.all
  end


  def show
    @state = State.find(params[:id])
  end


  def new
    @state = State.new
  end


  def edit
    @state = State.find(params[:id])
  end


  def create
    @state = State.new(params[:state])

    if @state.save
    	redirect_to(admin_state_path(@state), :notice => 'State was successfully created.')
      else
        render :action => "new"
      end
  end


  def update
    @state = State.find(params[:id])

      if @state.update_attributes(params[:state])
        redirect_to(admin_state_path(@state), :notice => 'State was successfully updated.')
      else
        render :action => "edit"
      end
  end


  def destroy
    @state = State.find(params[:id])
    @state.destroy

    redirect_to(admin_states_url)
  end
end
