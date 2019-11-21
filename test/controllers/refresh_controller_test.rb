require 'test_helper'
require 'json'
#when accessing the response body, use the JSON library to parse the JSON

class RefreshControllerTest < ActionDispatch::IntegrationTest
    test "recieve new access token" do
    post refresh_url, headers: {"Authorization" => login_and_return_tokens["access"]}
    assert_response :ok
    end
end
