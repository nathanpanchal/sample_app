require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information should not increase user count" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "", email: "user@invalid", password: "foo",
        password_confirmation: "bar" }
    end
    assert_template 'users/new'
  end

  test "A valid signup should incrememnt user count by 1" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path user: { name: "Non Blank", email: "user@valid.com", password: "password",
        password_confirmation: "password" }
    end
    assert_template 'users/show'
  end

end
