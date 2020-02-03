require 'test_helper'

class Admin::WishlistsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get admin_wishlist_create_url
    assert_response :success
  end

  test "should get show" do
    get admin_wishlist_show_url
    assert_response :success
  end

  test "should get index" do
    get admin_wishlist_index_url
    assert_response :success
  end

  test "should get update" do
    get admin_wishlist_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_wishlist_destroy_url
    assert_response :success
  end

end