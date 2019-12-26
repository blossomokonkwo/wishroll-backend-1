require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "email_matches_format_regex" do
    user = User.new(email: "gb@aol")
    assert_no_match /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, user.email, "Email has to match the standard regex"
  end

  test "validates_presence_of_email" do
    user = User.new password: "testpassword"
    assert_not user.save, "The user must provide an email"
  end


end
