require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @test_user = User.new(name: "Example User", email: "user@example.com",
      password: 'foobar', password_confirmation: 'foobar')
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

  test "should accept valid email addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org 
                                  first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @test_user.email = valid_address
      assert @test_user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "should reject invalid email addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @test_user.email = invalid_address
      assert_not @test_user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    # create a duplicate user
    duplicate_user = @test_user.dup
    # change the email of the duplicate user to uppercase
    duplicate_user.email = @test_user.email.upcase
    # save the test user to the database so we have a record to test against
    @test_user.save
    # make sure that the duplicate user is NOT a valid user
    assert_not duplicate_user.valid?
  end

end
