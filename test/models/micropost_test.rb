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
    assert_not @micropost.valid?
  end

  test 'content should be present' do
    @micropost.content = '     '
    assert_not @micropost.valid?
  end

  test 'content should be at most 140 characters in length' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  test 'micropost display order should be most recent first' do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
