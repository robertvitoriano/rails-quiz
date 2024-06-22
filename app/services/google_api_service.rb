
class GoogleApiService
  include HTTParty
  base_uri 'https://www.googleapis.com'

  def initialize(access_token)
    @access_token = access_token
  end

  def fetch_user_info
    response = self.class.get('/oauth2/v2/userinfo', headers: { 'Authorization' => "Bearer #{@access_token}" })
    parse_response(response)
  end

  private

  def parse_response(response)
    if response.success?
      JSON.parse(response.body)
    else
      { error: 'Failed to fetch user info from Google API' }
    end
  end
end
