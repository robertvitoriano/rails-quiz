class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {}, level = "user")
    @headers = headers
    @level = level
  end

  def call
    user
  end

  private

  attr_reader :headers
  attr_reader :level


  def user
    @user ||= User.where({id: decoded_auth_token[:user_id], level:level})[0] if decoded_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
  end

  def decoded_auth_token
    puts http_auth_header
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add(:token, 'Missing token')
    end
    nil
  end
end
