class AdminController < ApplicationController
  before_filter :check_admin

  protected
  def check_admin
    begin
      user = User.find(self.user_id)
      if ! ['jdagger', 'rcalvert'].include?(user.username)
        redirect_to logout_url
      end
    rescue
      redirect_to logout_url
    end
  end
end
