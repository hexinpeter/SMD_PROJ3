require 'test_helper'

class PredictionControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get show_area" do
    get :show_area
    assert_response :success
  end

end
