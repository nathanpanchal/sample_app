require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    # Clears all pending test deliveries
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test 'password resets request invalid email then valid email' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Post invalid email
    post password_resets_path, password_reset: {email: ''}
    assert_not flash.empty?
    # Test that the user is redirected to the new password reset form
    assert_template 'password_resets/new'
    post password_resets_path, password_resets: {email: @user.email}
    # tests that the code should generate a new reset digest when a valid email is
    # entered in the passowrd resets request form
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # Did the code send out exactly one email
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

end
