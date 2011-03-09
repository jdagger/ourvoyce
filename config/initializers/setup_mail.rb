ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_url_options[:host] = "www.directeddata.com"

ActionMailer::Base.smtp_settings = {
  :address              => "mail.ourvoyce.com",
  :port                 => 26,
  #:domain               => 'baci.lindsaar.net',
  :user_name            => 'accounts@ourvoyce.com',
  :password             => 'oV$igNup27',
  :authentication       => 'plain' } #,
  #:enable_starttls_auto => true  }

