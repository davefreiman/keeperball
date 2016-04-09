require 'rails_helper'

describe User do
  def new_user
    User.new(email: 'test@test.co', password: 'somepassword')
  end

  describe 'encryption' do
    let (:crypt) do
      ActiveSupport::MessageEncryptor.new(
        Rails.application.secrets.secret_key_base
      )
    end
    context 'when a new user is initialized' do
      it 'leaves unencrypted fields as is' do
        user = User.new
        expect(user.yahoo_oauth_token).to eq nil
        expect(user.yahoo_access_token).to eq nil
      end
    end

    context 'when a user is saved' do
      it 'encrypts fields that require it' do
        new_user.update_attributes(
          yahoo_oauth_token: 'unencrypted_token'
        )

        #shouldn't be searchable
        expect(User.where(yahoo_oauth_token: 'unencrypted_token').count).to eq(0)
      end
    end

    context 'when a user is retrieved' do
      it 'should allow us to access unencrypted values' do
        new_user.update_attributes(
          yahoo_oauth_token: 'unencrypted_token'
        )

        expect(User.last.yahoo_oauth_token).to eq('unencrypted_token')
        expect(User.last.yahoo_oauth_token_secret).to eq nil
      end
    end
  end
end