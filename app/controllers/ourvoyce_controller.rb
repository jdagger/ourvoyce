class OurvoyceController < ApplicationController
  skip_before_filter :require_user, :only => [:index]

  def index
    @states = State.find(:all, :order => "name")
    @current_question = CurrentQuestion.where("start_date < ?", Time.now).where("end_date > ?" , Time.now).where("active = ?", 1).first
    @current_user = current_user
    if ! @current_question.nil?
      if ! current_user.nil?
        support = CurrentQuestionSupport.where("current_question_id" => @current_question.id, "user_id" => @current_user.id).first
        if ! support.nil?
          @current_question_support = support.support_type
        end
      end
    else
      @current_question = CurrentQuestion.new :question_text => 'No question selected'
      @current_question_support = -1
    end
  end

	def vote
		support_type = -1

		if (!params[:thumbs_up].nil?)
			support_type = 1
		elsif (!params[:thumbs_down].nil?)
			support_type = 0
		elsif (!params[:neutral].nil?)
			support_type = 2
    elsif (!params[:clear].nil?)
      support_type = -1
		end

		CurrentQuestionSupport.change_support(params[:item_id], @current_user.id, support_type)

    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.json { render :json => { :result => 'success' }}
    end
	end
end
