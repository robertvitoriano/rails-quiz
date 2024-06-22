class AuthenticateUser
  prepend SimpleCommand

  def initialize(username_or_token, password = nil)
    @username_or_token = username_or_token
    @password = password
  end

  def call
    if using_username_password?
      authenticate_with_username_password
    elsif using_oauth?
      authenticate_with_oauth
    else
      errors.add :authentication, 'Invalid authentication method'
      nil
    end
  end

  private

  attr_accessor :username_or_token, :password

  def using_username_password?
    password.present?
  end

  def using_oauth?
    !using_username_password? && username_or_token.present?
  end

  def authenticate_with_username_password
    user = User.find_by(username: username_or_token)
    return nil unless user
    return nil unless user.authenticate(password)

    token = JsonWebToken.encode(user_id: user.id, level: user.level)

    {
      token: token,
      user: {
        id: user.id,
        name: user.name,
        username: user.username,
        level: user.level,
        avatar: user.avatar
      }
    }
  end

  def authenticate_with_oauth
    google_service = GoogleApiService.new(username_or_token)
    user_info = google_service.fetch_user_info
    
    if user_info[:error].present?
      errors.add :oauth, user_info[:error]
      return nil
    end
    
    user = User.find_or_initialize_by(email: user_info['email'])
    user.name = user_info['name']
    user.username = user_info['given_name'] || user_info['email'].split('@').first
    user.avatar = user_info['picture']
    user.save!
    
    generate_auth_response(user)
  end

  def generate_auth_response(user)
    token = JsonWebToken.encode(user_id: user.id, level: user.level)

    {
      token: token,
      user: {
        id: user.id,
        name: user.name,
        username: user.username,
        level: user.level,
        avatar: user.avatar
      }
    }
  end
end
