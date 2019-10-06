require 'test_helper'
require 'json'

class LogoutControllerTest < ActionDispatch::IntegrationTest
  test "logout_user" do
    post login_url, params: {email: users(:greatokonkwo).email, password: "wweraw45"}
    tokens = JSON.parse @response.body 
    delete logout_url, headers: {"Authorization" => tokens["access"]}
    assert_response :ok
  end

end
