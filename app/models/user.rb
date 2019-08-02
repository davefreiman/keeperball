class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :email, type: String
  field :admin, type: Boolean, default: false
  field :password_digest, type: String
  field :yahoo_oauth_token, type: String
  field :yahoo_oauth_token_secret, type: String
  field :yahoo_access_token, type: String
  field :yahoo_access_token_secret, type: String
  field :yahoo_access_token_expiry, type: Time
  field :yahoo_oauth_session_identifier, type: String
  field :yahoo_access_refresh_token, type: String
  field :google_access_token, type: String
  field :google_refresh_token, type: String
  field :google_access_token_expiry, type: Time

  has_one :roster, class_name: 'Keeperball::Roster'

  has_secure_password

  validates :email, {
    presence: true,
    uniqueness: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  }

  before_save :encrypt_tokens
  after_find :decrypt_tokens

  def has_expired_access_token?
    Time.now > yahoo_access_token_expiry
  end

  def has_expired_google_token?
    Time.now > google_access_token_expiry
  end

  private

  def encrypted_fields
    [
      :yahoo_oauth_token,
      :yahoo_oauth_token_secret,
      :yahoo_access_token,
      :yahoo_access_token_secret,
      :yahoo_oauth_session_identifier,
      :google_access_token,
      :yahoo_access_refresh_token
    ]
  end

  def encrypt_tokens
    encrypted_fields.each do |field|
      if self.send(field).present?
        self.send("#{field}=", crypt.encrypt_and_sign(read_attribute(field)))
      end
    end
  end

  def decrypt_tokens
    encrypted_fields.each do |field|
      if self.send(field).present?
        self.send("#{field}=", crypt.decrypt_and_verify(read_attribute(field)))
      end
    end
  end

  def crypt
    @crypt ||= ActiveSupport::MessageEncryptor.new(
      Rails.application.secrets.secret_key_base[0..31]
    )
  end
end
