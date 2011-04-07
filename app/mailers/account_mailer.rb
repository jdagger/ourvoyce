class AccountMailer < ActionMailer::Base
  default :from => "accounts@ourvoyce.com"
  default_url_options[:host] = "www.ourvoyce.com"

  def password_reset_email(user)
    @password_reset_url = edit_reset_password_url(user.perishable_token)
    mail(:to => user.email, :subject => 'ourvoYce Password Reset')
  end

  def verification_email(user)
    @verification_url = verify_url(user.perishable_token)
    mail(:to => user.email, :subject => 'ourvoYce Email Verification')
  end

  def forgot_username_email(user)
    @username = user.login
    mail(:to => user.email, :subject => 'ourvoYce Username Reminder')
  end
end
