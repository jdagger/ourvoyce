class CurrentQuestionsController < ApplicationController

  # GET /current_questions
  def index
    @current_questions = CurrentQuestion.find(:all, :order => :start_date)
  end

  # GET /current_questions/1
  def show
    @current_question = CurrentQuestion.find(params[:id])
  end

  # GET /current_questions/new
  def new
    @current_question = CurrentQuestion.new
  end

  # GET /current_questions/1/edit
  def edit
    @current_question = CurrentQuestion.find(params[:id])
  end

  # POST /current_questions
  def create
    @current_question = CurrentQuestion.new(params[:current_question])

    if @current_question.save
      redirect_to(current_question_path(@current_question), :notice => 'CurrentQuestion was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /current_questions/1
  def update
    @current_question = CurrentQuestion.find(params[:id])

    if @current_question.update_attributes(params[:current_question])
      redirect_to(current_question_path(@current_question), :notice => 'CurrentQuestion was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /current_questions/1
  def destroy
    @current_question = CurrentQuestion.find(params[:id])
    @current_question.destroy

    redirect_to(current_questions_url)
  end
end
