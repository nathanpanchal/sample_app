require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @test_user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @test_user.valid?
  end

  test "name attribute should be present" do
    @test_user.name = "   "
    assert_not @test_user.valid?
  end

  test "user name should not exceed 50 characters" do
    @test_user.name = 'a' * 51
    assert_not @test_user.valid?
  end

  test "email attribute should be present" do
    @test_user.email = "   "
    assert_not @test_user.valid?
  end

  test "user email should not exceed 255 characters" do
    @test_user.name = 'a' * 244 + "@example.com"
    assert_not @test_user.valid?
  end

  test "email validatoin should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org 
                                  first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @test_user.email = valid_address
      assert @test_user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @test_user.email = invalid_address
      assert_not @test_user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

end
