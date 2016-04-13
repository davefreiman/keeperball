module Keeperball
  class Player
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, type: String
    field :player_key, type: String
    field :position, type: Array
    field :salary, type: Integer
    field :expiry, type: Integer
    field :contract_type, type: String

    belongs_to :roster, inverse_of: :players, class_name: 'Keeperball::Roster'

    validates :player_key, presence: true, uniqueness: true
    validates :name, presence: true
    validates :position, presence: true
    validates :salary, presence: true, numericality: true
    validates :expiry, presence: true, numericality: true
    validates :contract_type, presence: true
    validate :contract_type_valid

    cattr_accessor :allowed_contract_types
    self.allowed_contract_types = %w(none entry extension franchise)

    private

    def contract_type_valid
      return true if self.allowed_contract_types.include?(contract_type)
      errors[:contract_type].push('invalid')
    end
  end
end
