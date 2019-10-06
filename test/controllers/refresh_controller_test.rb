require 'test_helper'
require 'json'
#when accessing the response body, use the JSON library to parse the JSON

class RefreshControllerTest < ActionDispatch::IntegrationTest
    test "recieve new access token" do
    post login_url, params: {:email => "testuser@gmail.com", :password => "testpassword"}, as: :json
    tokens = JSON.parse @response.body
    post refresh_url, headers: {"Authorization" => tokens["access"]}
    assert_response :ok
    end
end
