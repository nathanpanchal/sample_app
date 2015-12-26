require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    # Clears all pending test deliveries
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test 'password resets' do
    # --Generate password reset token via the forgot password form--
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Post invalid email
    post password_resets_path, password_reset: {email: ''}
    assert_not flash.empty?
    # Test that the user is redirected to the new password reset form upon invalid email post
    assert_template 'password_resets/new'
    # Post valid email
    post password_resets_path, password_reset: {email: @user.email}
    # Tests that the code should generate a new reset digest when a valid email is
    # entered in the password resets request form
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # Did the code send out exactly one email
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # --Password reset form--
    user = assigns(:user)
    # submit email that does not exst in the system. Code should redirect to root URL
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    # Submit inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email , right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    # Tests if the hidden input field contains the user's email
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    # Invalid password and confirmation
    patch password_reset_path(user.reset_token), email: user.email, user: {password: 'foobaz',
                                                                           password_confirmation: 'booo'}
    # Tests if there is an error present because there is no second argument provided
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(user.reset_token), email: user.email, user: {password: '',
                                                                           password_confirmation: ''}
    assert_select 'div#error_explanation'
    # Valid password and confirmation
    patch password_reset_path(user.reset_token), email: user.email, user: {password: 'foobar',
                                                                           password_confirmation: 'foobar'}
    assert is_logged_in?
    assert_not  flash.empty?
    assert_redirected_to user
  end

  test 'expired password reset token' do
    get new_password_reset_path
    post password_resets_path, password_reset: {email: @user.email}
    @user = assigns(:user)
    # expires the password reset token
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
      email: @user.email,
      user: {password: 'foobar', password_confirmation: 'foobar'}
    assert_response :redirected
    follow_redirect!
    # checks if the word expired appears in the redirected html body
    assert_match /expired/i , response.body
  end

end
