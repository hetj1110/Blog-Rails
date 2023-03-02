class WelcomeMailer < ApplicationMailer
  default from: 'hetjoshi@gmail.com'
  
  def send_greetings(user)
    @user = user

    mail to: user.email, subject: "Thanks for registering" 
  end
end
