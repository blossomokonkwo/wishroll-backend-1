require 'test_helper'
require 'faker'

class UserTest < ActiveSupport::TestCase
  # test "email_matches_format_regex" do
  #   user = User.new(email: "gb@aol")
  #   assert_no_match /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, user.email, "Email has to match the standard regex"
  # end

  # test "validates_presence_of_email" do
  #   user = User.new password: "testpassword"
  #   assert_not user.save, "The user must provide an email"
  # end

  test "validates_presence_of_username" do
    user = User.new email: "test@gmail.com", password: "testpassword", birth_date: Faker::Date.birthday(min_age: 18, max_age: 65), name: Faker::Name.name
    assert user.save, "Users must have a username inorder to create an account"
  end

end
