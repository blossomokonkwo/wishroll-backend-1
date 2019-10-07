require 'test_helper'
require 'json'

class AddProfilePictureControllerTest < ActionDispatch::IntegrationTest
  test "can_upload_image" do
    post login_url, params: {:email => users(:greatokonkwo).email, :password => "wweraw45"}, as: :json
    tokens = JSON.parse @response.body
    post "http://localhost:3000/profile/edit", headers: {"Authorization" => tokens["access"]},
    params: {profile_image: File.open("test/fixtures/files/billgates.jpg")}
    assert_response :success
  end

  test "can_remove_profile_image" do 
    post login_url, params: {:email => users(:greatokonkwo).email, :password => "wweraw45"}, as: :json
    tokens = JSON.parse @response.body
    delete "http://localhost:3000/profile/edit", headers: {"Authorization" => tokens["access"]}
    assert_response :success
  end 
end
