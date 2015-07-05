class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # Confirms a logged-in user.
  # because the microposts and users controllers both need
  # authentication first
  # this method will instantiate a User object called
  # @current_user, which is used to identify the user in
  # the current session
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = "Please log in."
    redirect_to login_url
  end
end
