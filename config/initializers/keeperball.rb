Keeperball::Application.configure do
  config.domain = 'friedgoods.dev'

  config.google_auth = Rails.application.secrets.google_auth
  config.google_sheet_id = Rails.application.secrets.google_drive[:sheet_id]

  config.yahoo_league_ids = { 2016 => '353.l.61815' }
  config.current_year = 2016
end