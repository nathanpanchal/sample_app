require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information should not increase user count" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "", email: "user@invalid", password: "foo",
        password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

  test "A valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: { name: "Example User",
                                           email: "user@valid.com",
                                           password: "password",
                                           password_confirmation: "password" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Attempt to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # assert_template 'users/show'
    # assert_not flash.empty?
    # assert is_logged_in?
  end

end
