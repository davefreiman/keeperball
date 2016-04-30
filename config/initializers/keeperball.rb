Keeperball::Application.configure do
  config.domain = 'friedgoods.dev'

  config.google_auth = Rails.application.secrets.google_auth
end