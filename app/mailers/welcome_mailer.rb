class WelcomeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.welcome_mailer.send_greetings.subject
  #
  def send_greetings(user)
    @user = user

    mail to: user.email, subject: "Thanks for registering" 
  end
end
