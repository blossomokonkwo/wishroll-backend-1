require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get user account" do
    get users_url, headers: {"Authorization" => login_and_return_tokens["access"]}
    assert_response :success
  end

end
