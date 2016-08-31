require 'test_helper'

class ParentsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get parents_show_url
    assert_response :success
  end

end
