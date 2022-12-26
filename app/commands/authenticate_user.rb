class AuthenticateUser
  prepend SimpleCommand

  def initialize(username, password)
    @username = username
    @password = password
  end

  def call
    if user
      token = JsonWebToken.encode(user_id: user.id, level: user.level)

      return {
        token: token,
        user:{
          id:user.id,
          name:  user.name,
          username: user.username,
          level: user.level
        }
      }

    end
  end

  private

  attr_accessor :username, :password

  def user
    user = User.where({username: username})[0]
    return user if user && user.authenticate(password)
    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
