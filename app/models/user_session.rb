class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages true
  consecutive_failed_logins_limit 10
  failed_login_ban_for 1.hour
end