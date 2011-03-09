class AccountMailer < ActionMailer::Base
  default :from => "accounts@ourvoyce.com"

  def password_reset_email(user)
    #@user = user
    @password_reset_url = edit_reset_password_url(user.perishable_token)
    Rails.logger.error "URL: #{@password_reset_url}"
    mail(:to => user.email, :subject => 'Password Reset')
  end
end
