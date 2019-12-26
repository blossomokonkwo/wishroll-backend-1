require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  test "can create tag" do
    post user_tag_url, params: {text: tags(:tag_one).text, post_id: posts(:post_one).id}, as: :json
    assert_response :success
  end
end
