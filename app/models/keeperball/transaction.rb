module Keeperball
  class Transaction
    include Mongoid::Document
    include Mongoid::Timestamps
    include Seasonable
    include Keeperball::ViewModels::TransactionViewModel

    field :move_type, type: String
    field :transaction_key, type: String
    field :completed_at, type: DateTime
    field :processed, type: Boolean, default: false
    field :pending, type: Boolean, default: false

    embeds_many :details,
      class_name: 'Keeperball::Transaction::Detail'

    scope :unprocessed, -> { where(:processed => false) }

    validates :transaction_key, presence: true, uniqueness: true
    validate :move_type_valid
    validate :details_present

    cattr_accessor :allowed_move_types
    self.allowed_move_types = %w(add trade)

    private

    def self.yahoo_reference_key
      :transaction_key
    end

    def move_type_valid
      return true if self.allowed_move_types.include?(move_type)
      errors[:move_type].push('invalid')
    end

    def details_present
      return true unless details.empty?
      errors[:details].push('can not be empty')
    end
  end
end
