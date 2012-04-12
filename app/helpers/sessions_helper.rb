module SessionsHelper

  # Reference notes: http://api.rubyonrails.org/classes/ActionDispatch/Cookies.html
  # If the Remember Me checkbox was checked, it uses the permanent cookie. Otherwise, use the temp cookie.
  # Holy cow, I was creating a new user from a fresh reset of the DB and it died on me, because the session never
  # existed yet
  def sign_in(user)
    #might not have worked because of the before_save filter/callback whatever it is
    #user.update_attributes(:last_sign_in_time => DateTime.now)
    if params[:session] && params[:session][:remember_me].to_i == 1
      cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    else
      cookies.signed[:remember_token] = [user.id, user.salt]
    end
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
