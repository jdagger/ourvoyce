
class Admin::GovernmentsController < ApplicationController

  # GET /governments
  def index
    @governments = Government.all
  end

  # GET /governments/1
  def show
    @government = Government.find(params[:id])
  end

  # GET /governments/new
  def new
    @government = Government.new
  end

  # GET /governments/1/edit
  def edit
    @government = Government.find(params[:id])
  end

  # POST /governments
  def create
    @government = Government.new(params[:government])

      if @government.save
        redirect_to(admin_government_path(@government), :notice => 'Government was successfully created.')
      else
        render :action => "new"
      end
  end

  # PUT /governments/1
  def update
    @government = Government.find(params[:id])

      if @government.update_attributes(params[:government])
        redirect_to(admin_government_path(@government), :notice => 'Government was successfully updated.')
      else
        render :action => "edit"
      end
  end

  # DELETE /governments/1
  def destroy
    @government = Government.find(params[:id])
    @government.destroy

	redirect_to(admin_governments_url)
  end
end
