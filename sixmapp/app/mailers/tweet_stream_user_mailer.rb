class SchoolLibraryContactMailer < ActionMailer::Base
  default from: Rails.configuration.admin_email

  def confirmed_email(user)
    @user = user
    subject = "Confirmation for the new account created by #{user.name}"
    mail(to: @user.email, subject: subject)
  end
end
