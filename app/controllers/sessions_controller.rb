class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    puts "\nin session controller:"
    puts user.inspect
    if user && user.authenticate(params[:session][:password])
      # to detect whether the user is activated or not
      if user.activated?
        # Log the user in and redirect to the user's show page.
        # for permanent connections
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        # for semi-permanent connections -> generates a temporary cookie
        log_in(user)
        redirect_to user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
