module Keeperball
  class Transaction::Detail
    include Mongoid::Document
    include Mongoid::Timestamps

    field :player_key, type: String
    field :detail_type, type: String
    field :source, type: String
    field :destination, type: String
    field :cap, type: Integer

    embedded_in :transaction,
      class_name: 'Keeperball::Transaction',
      inverse_of: :detail

    validates :detail_type, presence: true
    validates :source, presence: true
    validates :destination, presence: true
    validate :player_or_cap
    validate :detail_type_valid

    cattr_accessor :allowed_detail_types
    self.allowed_detail_types = %w(waiver free_agent trade)

    private

    def detail_type_valid
      return true if self.allowed_detail_types.include?(detail_type)
      errors[:detail_type].push('invalid')
    end

    def player_or_cap
      return true if player_key.present? || cap.present?
      errors[:player_or_cap].push('must be present')
    end
  end
end
