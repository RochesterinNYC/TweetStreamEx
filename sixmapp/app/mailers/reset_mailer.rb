class ResetMailer < ActionMailer::Base
  default from: Rails.configuration.admin_email

  def reset_password_email(user)
    @user = user
    subject = "TweetStream Reset Password Link for #{user.name}"
    mail(to: @user.email, subject: subject)
  end
end
