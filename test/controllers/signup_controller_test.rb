require 'test_helper'

class SignupControllerTest < ActionDispatch::IntegrationTest
  test "successful signup" do
    post signup_url, 
    params: {email: "randomemail@gmail.com", password: "mypassword", 
    first_name: "First", last_name: "Last", bio: "My Bio", username: "ranmone99"}, as: :json
    assert_response :success
  end
end
