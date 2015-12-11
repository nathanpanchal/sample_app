require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    # Clears all pending test deliveries
    ActionMailer::Base.deliveries.clear
    @user = user(:michael)
  end

  test 'password resets' do
    get new_password_rests_path
    assert_template 'password_rest/new'
    # Post invalid email
    post password_resets_path, password_reset: {email: ''}
    assert_not flash.empty?
    # Test that the user is redirected to the new password reset form
    assert_template 'password_resets/new'
  end

end
