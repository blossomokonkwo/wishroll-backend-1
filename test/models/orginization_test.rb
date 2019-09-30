require 'test_helper'

class OrginizationTest < ActiveSupport::TestCase
  #test passes 
  test "orginization_name_uniqness" do
    school =  Orginization.new(name: "Nassua Community College")
    assert school.save
  end

  #test passes 
  test "orginization_has_many_relationship" do 
    school =  Orginization.new(name: "New York University")
    user = User.first
    user.orginization = school
    user2 = User.last
    user2.orginization = Orginization.first
    assert_not user.orginization == user2.orginization
  end
  test "orginization_users_count" do
    User.first.orginization = Orginization.first
    org = Orginization.first
    assert org.users.size == 1
  end
end
