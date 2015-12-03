class PasswordResetsController < ApplicationController
  before_action :get_user,  only: [:edit, :update]
  before_action :valid_user,  only: [:edit, :update]
  before_action :check_expiration,  only: [:edit, :update]

  def new
  end

  # creates password reset digest and sends the password reset email.
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found'
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      # Explicitly deals with a submission of a blank password field.
      @user.errors.add(:password, 'cant be empty')
      # Render the edit form again
      render 'edit'
    # If the submitted form contains both a valid password and confirmation
    # then submit the form.
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # Before filters

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Returns true if a user exists, is activated, and is authenticated.
    def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = 'Password reset has expired.'
        redirect_to new_password_reset_url
      end
    end

end
