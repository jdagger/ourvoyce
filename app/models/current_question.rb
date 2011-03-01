class CurrentQuestion < ActiveRecord::Base
  has_many :current_question_supports
  has_many :users, :through => :current_question_supports
end
