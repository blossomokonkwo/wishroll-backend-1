require 'test_helper'

class LoginControllerTest < ActionDispatch::IntegrationTest
  test "successful signup" do
  post login_url, params: {:email => "testuser@gmail.com", :password => "testpassword"}, as: :json
  assert_response :success
 end

 

end
