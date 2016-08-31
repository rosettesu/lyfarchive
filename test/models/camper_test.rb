require 'test_helper'

class CamperTest < ActiveSupport::TestCase

  def setup
    @parent = parents(:jessica)
    @camper = campers(:jonathan)
    @parent.campers.build(@camper.attributes)
  end

  test "should be valid" do
    assert @camper.valid?
  end

  test "first name should be present" do
    @camper.first_name = "    "
    assert_not @camper.valid?
  end

  test "last name should be present" do
    @camper.last_name = "    "
    assert_not @camper.valid?
  end

  test "gender should be present" do
    @camper.gender = nil
    assert_not @camper.valid?
  end

  test "birthdate should be present" do
    @camper.birthdate = "    "
    assert_not @camper.valid?
  end

  test "medical information and medication should be present" do
    @camper.medical = "    "
    assert_not @camper.valid?
  end

  test "dietary restrictions and allergy information should be present" do
    @camper.diet_allergies = "    "
    assert_not @camper.valid?
  end

  # fails but i think we're gonna change the uniqueness params anyway
  test "first name + last name + birthdate should be unique" do
    @parent.save
    duplicate_camper = @camper.dup
    @camper.save
    assert_not duplicate_camper.valid?
  end

  # possibly move the following to a separate test for email address validations
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foobar.COM
                         A_VALID-EMAIL@foo.bar.org first.last@sample.jp
                         eric+steph@bar.cn]
    valid_addresses.each do |valid_address|
      @camper.email = valid_address
      assert @camper.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org
                           user.name@example.foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @camper.email = invalid_address
      assert_not @camper.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPlE.coM"
    @camper.email = mixed_case_email
    @camper.save
    assert_equal mixed_case_email.downcase, @camper.reload.email
  end
end
