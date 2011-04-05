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
  end

  def iphone 
    redirect_to 'http://itunes.apple.com/us/app/ourvoyce/id427045482?mt=8'
  end
  
  def members
  end

  def idol
  end
  
  def mcdonalds
  end
  
  def starbucks
  end
  
end
