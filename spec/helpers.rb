module Helpers
  def json_response
    JSON.parse response.body
  end

  def headers_of(user)
    { 'HTTP_AUTHORIZATION' => "Bearer #{user.access_token}" }
  end
end