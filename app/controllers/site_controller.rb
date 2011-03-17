class SiteController < ApplicationController
  skip_before_filter :require_user

  def help
  end

  def contact
  end

  def about
  end

  def terms
  end

  def privacy
  end
  
  def work
  end

  def donate
    redirect_to 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YL99BHV7HWQCG'
  end
end
