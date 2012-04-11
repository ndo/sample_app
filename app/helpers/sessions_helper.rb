module SessionsHelper

  # Reference notes: http://api.rubyonrails.org/classes/ActionDispatch/Cookies.html
  # If the Remember Me checkbox was checked, it uses the permanent cookie. Otherwise, use the temp cookie.
  # Holy cow, I was creating a new user from a fresh reset of the DB and it died on me, because the session never
  # existed yet
  # Reference notes: http://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-update_attribute
  # Initially I was using update_attributes which kept returning false for some odd reason I could not figure out.
  # So instead, I use update_attribute. Should probably ask the professor why the other one didn't work.
  # Tried update_attributes again, and I don't seem to be having the previous problem, but the time doesn't seem
  # to be updating
  def sign_in(user)
   # user.update_attributes(:last_sign_in_time => DateTime.now, :name => user.name, :email => user.email, 
   #:encrypted_password => user.encrypted_password, :salt => user.salt)
    user.update_attributes(:last_sign_in_time => DateTime.now)
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
