class OauthController < ApplicationController
  before_filter :require_login

  def authorize
    auth = Keeperball::YahooApi::Authorization.new(oauth_params, current_user)
    redirect_to auth.authorize_url
  end

  def callback
    auth = Keeperball::YahooApi::Authorization.new(oauth_params, current_user)

    begin
      access = auth.access_token
      current_user.update_attributes(
        yahoo_access_token: access.token,
        yahoo_access_token_expiry: Time.now + access.expires_in.seconds,
        yahoo_oauth_session_identifier: access.params[:oauth_session_handle],
        yahoo_access_refresh_token: access.refresh_token
      )
      redirect_to root_path, notice: 'authorized'
    rescue Exception => e

      redirect_to root_path, notice: e.message
    end
  end

  private

  def oauth_params
    params.select do |k, _v|
      k.to_s.include?('oauth') || k == 'code'
    end.compact
  end
end
