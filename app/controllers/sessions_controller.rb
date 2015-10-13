class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    # If the user exists (not nil per line 6) and the password is authenticated log them in.
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        # An alternate if/then/else statement. If the remember me box is checked (== '1')
        # then remember the user else forget the user.
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = 'Account not activated. '
        message += 'Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      # render the sessions view "new"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
