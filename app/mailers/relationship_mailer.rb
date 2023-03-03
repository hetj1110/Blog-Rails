class RelationshipMailer < ApplicationMailer

  def started_following_user(user)
    @user = user

    mail to: @user.email, subject:"Started Following You"
  end

  def stops_following_user(user)
    @user = user

    mail to: @user.email, subject:"Stoped Following You"
  end
end
