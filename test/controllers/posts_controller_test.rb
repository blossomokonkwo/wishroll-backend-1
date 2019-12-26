require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should retrieve a post" do
    post_num = 60
    get "http://localhost:3000/user/posts/#{post_num}", headers: {"Authorization" => login_and_return_tokens["access"]}
    assert_response :success
  end

end
