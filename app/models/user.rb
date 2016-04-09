class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :email, type: String
  field :password_digest, type: String
  field :yahoo_access_token, type: String
  field :yahoo_access_token_secret, type: String
  has_secure_password

  validates :email, {
    presence: true,
    uniqueness: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  }

  before_save :encrypt_tokens
  after_find :decrypt_tokens

  private

  def encrypt_tokens
    if yahoo_access_token.present?
      self.yahoo_access_token = crypt.encrypt_and_sign(yahoo_access_token)
    end
    if yahoo_access_token_secret.present?
      self.yahoo_access_token_secret =
        crypt.encrypt_and_sign(yahoo_access_token_secret)
    end

  end

  def decrypt_tokens
    if yahoo_access_token.present?
      self.yahoo_access_token = crypt.decrypt_and_verify(yahoo_access_token)
    end

    if yahoo_access_token_secret.present?
      self.yahoo_access_token_secret =
        crypt.decrypt_and_verify(yahoo_access_token_secret)
    end
  end

  def crypt
    @crypt ||= ActiveSupport::MessageEncryptor.new(
      Rails.application.secrets.secret_key_base
    )
  end
end
