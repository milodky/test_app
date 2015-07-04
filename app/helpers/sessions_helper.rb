module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    # places a temporary cookie on the user’s browser containing an encrypted
    # version of the user’s id, which allows us to retrieve the id on subsequent
    # pages using session[:user_id]
    #
    # as far as I know, the way to encrypt and decrypt is that the []= operator
    # enciphers and [] operator deciphers
    session[:user_id] = user.id
  end

  def current_user
    puts '######################'
    puts session[:user_id].inspect

    puts '%%%%%%%%%%%%%%%%%%%%%%'
    puts cookies.signed[:user_id].inspect

    puts '@@@@@@@@@@@@@@@@@@@@@@'
    puts @current_user.present?

    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
puts user.present?
      if user && user.authenticated?(cookies[:remember_token])
        puts 'ain\'t I in?'
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    # Because we want the user id to be paired with the permanent remember token,
    # we should make it permanent as well, which we can do by chaining the signed
    # and permanent methods:
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end


end
