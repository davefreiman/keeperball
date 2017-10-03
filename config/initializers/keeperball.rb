Keeperball::Application.configure do
  config.domain = {
    'development' => 'friedgoods.com',
    'production' => 'keeperball.friedgoods.com'
  }[Rails.env]

  config.google_auth = Rails.application.secrets.google_auth
  config.google_sheet_id = Rails.application.secrets.google_drive[:sheet_id]

  config.yahoo_league_ids = { 2016 => '353.l.61815', 2017 => '364.l.76053', 2018 => '375.l.47486'}
  config.yahoo_game_ids = { 2016 => '353', 2017 => '364', 2018 => '375' }
  config.current_year = 2018
end
