require 'test_helper'

class CampersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get campers_new_url
    assert_response :success
  end

end
