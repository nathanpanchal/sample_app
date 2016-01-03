require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @micropost = Micropost.new(content: "Some acceptable content", user_id: @user.id)
  end

  # tests if a micropost is valid from a database submission standpoint. valid? is an active record function.
  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'user ID should be present' do
    @micropost.user_id = nil
    assert_not @microposrt.valid?
  end

end
