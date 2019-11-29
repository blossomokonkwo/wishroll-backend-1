require 'test_helper'

class FriendsControllerTest < ActionDispatch::IntegrationTest
  test "adding a friend" do
    post login_url, params: {:email => "randomemail@gmail.com", :password => "testpassword"}, as: :json
    post "http://localhost:3000/friends/add", params: {friend_id: 2}
    assert_response :success 
  end
end
