# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Yonodesperdicio::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => Rails.application.secrets.emails["smtp_username"],
  :password => Rails.application.secrets.emails["smtp_password"],
  :address => Rails.application.secrets.emails["smtp_address"],
  :port => Rails.application.secrets.emails["smtp_port"],
  :authentication => :plain,
  :enable_starttls_auto => true,
  :openssl_verify_mode => "none"
}
