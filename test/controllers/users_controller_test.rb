require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get user account" do
    get "http://localhost3000/profile", headers: {"Authorization" => login_and_return_tokens["access"]}
    assert_response :success
  end

end
