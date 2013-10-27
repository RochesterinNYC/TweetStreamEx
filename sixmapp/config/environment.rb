# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Sixmapp::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => 'RochesterinNYC',
  :password => 'TweetStream0',
  :domain => 'jamesrwen.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
