# Preview all emails at http://localhost:3000/rails/mailers/relationship_mailer
class RelationshipMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/relationship_mailer/started_following_user
  def started_following_user
    RelationshipMailer.started_following_user
  end

  # Preview this email at http://localhost:3000/rails/mailers/relationship_mailer/stops_following_user
  def stops_following_user
    RelationshipMailer.stops_following_user
  end

end
