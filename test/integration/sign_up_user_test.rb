require 'test_helper'
require 'json'

class SignUpUserTest < ActionDispatch::IntegrationTest
  test "user_sign_up" do
    post signup_url, params: {email: "Integration@gmail.com", password: "Testpassword", 
    first_name: "Integration", last_name: "Test", bio: "I'm an integration test", username: "testuser"}
    assert_response :success
  end 

  test "login_an_existing_user" do
    post login_url, params: {email: users(:greatokonkwo).email, password: "wweraw45"}
    assert_response :success
  end
end
