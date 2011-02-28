class OurvoyceController < ApplicationController
  def index
    @states = State.find(:all, :order => "name")
    @current_question = CurrentQuestion.where("start_date < ?", Time.now).where("end_date > ?" , Time.now).where("active = ?", 1).first
    if ! @current_question.nil?
      support = CurrentQuestionSupport.where("current_question_id" => @current_question.id, "user_id" => self.user_id).first
      if ! support.nil?
        @current_question_support = support.support_type
      end
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

		CurrentQuestionSupport.change_support(params[:item_id], session[:user_id], support_type)

    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.json { render :json => { :result => 'success' }}
    end
	end
end
