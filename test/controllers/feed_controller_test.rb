require 'test_helper'

class FeedControllerTest < ActionDispatch::IntegrationTest
  test "can get feed" do
    get feed_url, headers: {"Authorization": login_and_return_tokens["access"]}
    assert_response :success
  end
end
