class CommentMailer < ApplicationMailer

  def comment_creation(comment)
    @comment = comment

    mail to: @comment.article.user.email, subject: "Some one has Commented on your Article"
  end

end
