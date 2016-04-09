class OauthController < ApplicationController
  before_filter :require_login

  def authorize
    auth = Keeperball::YahooApi::Authorization.new(oauth_params)
    session[:token] = auth.request_token.token
    session[:token_secret] = auth.request_token.secret
    redirect_to auth.request_token.authorize_url
  end

  def callback
    auth = Keeperball::YahooApi::Authorization.new(oauth_params)
    hash = {
      oauth_token: session[:token],
      oauth_token_secret: session[:token_secret]
    }
    token = OAuth::RequestToken.from_hash(auth.consumer, hash)

    begin
      access = token.get_access_token(oauth_params)
      current_user.update_attributes(
        yahoo_access_token: access.token,
        yahoo_access_token_secret: access.secret
      )
    rescue Exception => e
      flash.now[:error] = e.message
    end

    redirect_to root_path, notice: 'authorized'
  end

  private

  def oauth_params
    params.select do |k, v|
      k.to_s.include?('oauth')
    end.compact
  end
end