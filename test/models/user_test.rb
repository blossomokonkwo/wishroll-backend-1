require 'test_helper'

class UserTest < ActiveSupport::TestCase
  #test passes
  test "email_attribute_uniqness" do
      user = User.new(email: "gboy@gmail.com",
      password_digest: "wweraw45",
      first_name: "Blossom",
      last_name: "Okonkwo",
      bio: "I'm Blossom Okonkwo and I can do no wrong")
    assert_not user.save
  end
  #test passes
  test "name_presence" do
    user = User.new(email: "ggngnggn@gmail.com",
      password_digest: "wweraw45",
      first_name: "",
      last_name: "",
      bio: "I'm Blossom Okonkwo and I can do no wrong")
      assert_not user.save

  end
  #test passes
  test "bio_capacity_is_100" do
    user = User.new(email: "r@gmail.com",
      password_digest: "wweraw45",
      first_name: "HHh",
      last_name: "JJJ",
      bio: "I'm Blossom Okonkwo and I can do no wrong. fhfhfhhfhffhfhfh fhfhf fhhfhfhfjfhffjfjjjjjfjfjfjfjfjfjfjfjfjjfjfjfjfjfjfjfjfjfjfjfjfjfjfjfjfjfjfjfjffjfjfjfjfjfffjfjffjfjfjfjfjfjfjjfjfjffjjfjfjfjfjfjfjfjfjfjfjffjfjffjfjfjfjfj")
      assert_not user.save, "Bio capacity is 100 characters"

  end
  #email regex allows spaces in email. Ensure that on the client side (javascript) this is prohibited
  test "email_matches_format_regex" do
    user = User.new(email: "gb@aol")
    assert_no_match /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, user.email, "Email has to match the standard regex"
  end


end
