class ApplicationController < ActionController::API
  private
  def encode_token(user_id)
    payload = { user_id: user_id }
    JWT.encode(payload, api_secret, 'HS256')
  end

  def api_secret
    ENV["API_SECRET_KEY"]
  end

  def client_has_valid_token?
    !!current_user_id
  end

  def current_user_id
    begin
      token = request.headers["Authorization"].sub!('Bearer ', '')
      decoded_array = JWT.decode(token, api_secret, true, { algorithm: 'HS256' })
      payload = decoded_array.first
    rescue #JWT::VerificationError
      return nil
    end
    payload["user_id"]
  end

  def require_login
    render json: {error: 'Unauthorized'}, status: :unauthorized if !client_has_valid_token?
  end
end