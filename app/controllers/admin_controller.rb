class AdminController < ApplicationController
  before_filter :check_admin

  protected
  def check_admin
    begin
      user = User.find(@current_user.id)
      if ! ['jdagger', 'rcalvert'].include?(user.login)
        redirect_to logout_url
      end
    rescue
      redirect_to logout_url
    end
  end
end
