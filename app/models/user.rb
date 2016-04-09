class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :email, type: String
  field :password_digest, type: String
  field :access_token, type: String
  has_secure_password

  validates :email, presence: true, uniqueness: true

  before_save :encrypt_token
  after_find :decrypt_token

  private

  def encrypt_token
    return unless access_token.present?
    self.access_token = crypt.encrypt_and_sign(access_token)
  end

  def decrypt_token
    return unless access_token.present?
    self.access_token = crypt.decrypt_and_verify(access_token)
  end

  def crypt
    @crypt ||= ActiveSupport::MessageEncryptor.new(
      Rails.application.secrets.secret_key_base
    )
  end
end
