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

end
