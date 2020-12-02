task get_league_key: :environment do
  require 'keeperball/yahoo_api/authorization'

  def get_consumer(auth, current_user)
    raise StandardError "user must exist and be authed" unless
      current_user.present? && current_user.yahoo_access_token.present?

    OAuth2::AccessToken.from_hash(
      auth.consumer,
      access_token: current_user.yahoo_access_token,
      refresh_token: current_user.yahoo_access_refresh_token,
      expires_at: current_user.yahoo_access_token_expiry
    )
  end

  auth = Keeperball::YahooApi::Authorization.new
  authed_consumer = get_consumer auth, User.first
  response = authed_consumer.get("https://fantasysports.yahooapis.com/fantasy/v2/game/nba")
  parsed = Nokogiri::XML(response.body)
  puts parsed.css('game game_key').text
end
