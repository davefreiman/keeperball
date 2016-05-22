Keeperball::Application.configure do
  config.domain = 'friedgoods.dev'

  config.google_auth = Rails.application.secrets.google_auth
  config.google_sheet_id = Rails.application.secrets.google_drive[:sheet_id]
end