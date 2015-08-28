require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "index include pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select div.pagination
  end

end