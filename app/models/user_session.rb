class UserSession < Authlogic::Session::Base
  allow_http_basic_auth(false)

  validate :check_if_verified

  private
  def check_if_verified
    errors.add(:base, "You have not verified your account") unless attempted_record && (attempted_record.verified == 1)
  end
end
