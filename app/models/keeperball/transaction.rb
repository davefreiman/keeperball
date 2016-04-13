module Keeperball
  class Transaction
    include Mongoid::Document
    include Mongoid::Timestamps

    field :move_type, type: String
    field :transaction_key, type: String
    field :completed_at, type: DateTime

    embeds_many :details,
      class_name: 'Keeperball::Transaction::Detail'

    validates :transaction_key, presence: true, uniqueness: true
    validate :move_type_valid

    cattr_accessor :allowed_move_types
    self.allowed_move_types = %w(add trade)

    private

    def move_type_valid
      return true if self.allowed_move_types.include?(move_type)
      errors[:move_type].push('invalid')
    end
  end
end
