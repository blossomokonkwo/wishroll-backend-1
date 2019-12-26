require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should retrieve a post" do
    post_id = posts(:post_one).id
    get user_post_url(post_id), headers: {"Authorization" => login_and_return_tokens["access"]}
    assert_response :success
  end

end
