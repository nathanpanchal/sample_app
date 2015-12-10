require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    # clears all pending test deliveries
    ActionMailer::Base.deliveries.clear
    @user = user(:michael)
  end

end
