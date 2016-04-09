require 'rails_helper'

describe User do
  describe 'encryption' do
    context 'when a new user is initialized' do
      it 'leaves unencrypted fields as is' do
        user = User.new
        expect(user.yahoo_oauth_token).to eq nil
        expect(user.yahoo_access_token).to eq nil
      end
    end
  end
end