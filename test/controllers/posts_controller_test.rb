require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get resources" do
    get posts_url
    assert_response :success
  end

end
