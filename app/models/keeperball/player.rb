module Keeperball
  class Player
    include Mongoid::Document
    include Mongoid::Timestamps
    include Seasonable

    field :name, type: String
    field :player_key, type: String
    field :positions, type: Array
    field :salary, type: Integer, default: 0
    field :expiry, type: Integer, default: 0
    field :contract_type, type: String, default: 'none'

    belongs_to :roster, inverse_of: :players, class_name: 'Keeperball::Roster'

    validates :player_key, presence: true, uniqueness: true
    validates :name, presence: true
    validates :positions, presence: true
    validates :salary, presence: true, numericality: true
    validates :expiry, presence: true, numericality: true
    validates :contract_type, presence: true
    validate :contract_type_valid

    cattr_accessor :allowed_contract_types
    self.allowed_contract_types = %w(none entry extension franchise)

    def self.find_by_key(key)
      Keeperball::Player.where(player_key: key).first
    end

    private

    def self.yahoo_reference_key
      :player_key
    end

    def contract_type_valid
      return true if self.allowed_contract_types.include?(contract_type)
      errors[:contract_type].push('invalid')
    end
  end
end
