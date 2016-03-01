require 'test_helper'

class ConfigControllerTest < ActionController::TestCase
  test "should get init_site" do
    get :init_site
    assert_response :success
  end

end
