module ApplicationHelper
  include ImageHelper
  include VoteCssHelper

  def user_count
    User.all.count
  end
end
