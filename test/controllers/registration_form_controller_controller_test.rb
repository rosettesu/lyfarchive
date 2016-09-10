require 'test_helper'

class RegistrationFormControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get registration_form_controller_show_url
    assert_response :success
  end

  test "should get update" do
    get registration_form_controller_update_url
    assert_response :success
  end

end
