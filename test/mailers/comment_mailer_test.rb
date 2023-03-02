require "test_helper"

class CommentMailerTest < ActionMailer::TestCase
  test "comment_creation" do
    mail = CommentMailer.comment_creation
    assert_equal "Comment creation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
