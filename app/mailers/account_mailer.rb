class AccountMailer < ActionMailer::Base
  default :from => "accounts@ourvoyce.com"
  default_url_options[:host] = "www.ourvoyce.com"

  def password_reset_email(user)
    @password_reset_url = edit_reset_password_url(user.perishable_token)
    mail(:to => user.email, :subject => 'Password Reset')
  end

  def verification_email(user)
    #subject "OurVoyce Email Verification"
    #recipients user.email
    #sent_on Time.now
    #body :verification_url => verification_url(user.perishable_token)
    @verification_url = verification_url(user.perishable_token)
    mail(:to => user.email, :subject => 'OurVoyce Email Verification')
  end

  def forgot_username_email(user)
    #subject "OurVoyce Username"
    #recipients user.email
    #sent_on Time.now
    #body :username => user.login
    @username = user.login
    ail(:to => user.email, :subject => 'OurVoyce Username')
  end
end
