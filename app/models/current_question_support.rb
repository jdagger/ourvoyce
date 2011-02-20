class CurrentQuestionSupport < ActiveRecord::Base
  belongs_to :current_question
  belongs_to :user

  class << self
    def change_support current_question_id, user_id, support_type
      current_question = CurrentQuestion.find(current_question_id)
      user = User.find(user_id)

      current_question_support = CurrentQuestionSupport.where("current_question_id = ? and user_id = ?", current_question.id, user.id).first

      #deleting
      if(support_type.to_i < 0)
        if(!current_question_support.nil?)
          current_question_support.destroy
        end
      elsif(current_question_support.nil?)
        user.current_question_supports.create(:current_question => current_question, :support_type => support_type)
      else
        #if already exists, update
        current_question_support.support_type = support_type
        current_question_support.save
      end
    end
  end
end
