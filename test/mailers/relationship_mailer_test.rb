require "test_helper"

class RelationshipMailerTest < ActionMailer::TestCase
  test "started_following_user" do
    mail = RelationshipMailer.started_following_user
    assert_equal "Started following user", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "stops_following_user" do
    mail = RelationshipMailer.stops_following_user
    assert_equal "Stops following user", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
