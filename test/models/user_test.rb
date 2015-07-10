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

end
