task yahoo_runner: :environment do
  require 'keeperball/yahoo_api/authorization'

  auth = Keeperball::YahooApi::Authorization.new
  p auth.request_token
end

