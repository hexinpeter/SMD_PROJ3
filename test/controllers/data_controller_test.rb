require 'test_helper'

class DataControllerTest < ActionController::TestCase
  test "should get locations" do
    get :locations
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get show_area" do
    get :show_area
    assert_response :success
  end

end
