require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  # Returns true if a user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Creates a sessions hash depending on the type of test the method is called on.
  def log_in_as(user, options = {})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: {email: user.email, password: password, remember_me: remember_me}
    # Used for model and controller tests where we cannot post to the sessions path. Instead we must
    # modify the session hash directly.
    else
      session[:user_id] = user.id
    end
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      # Post via redirect is only defined in integration tests via inheritance.
      defined?(post_via_redirect)
    end

end
