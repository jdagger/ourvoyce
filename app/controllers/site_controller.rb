class SiteController < ApplicationController
  skip_before_filter :authorize
  skip_before_filter :basic_authentication

  def help
  end

  def terms
  end

  def privacy
  end
end