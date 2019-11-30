require 'test_helper'

class FriendsControllerTest < ActionDispatch::IntegrationTest
  test "adding a friend" do
    post "http://localhost:3000/friends/add", headers: {"Authorization": login_and_return_tokens["access"]}, params: {friend_: users(:cameronstone).username}
    assert_response :success 
  end
end
