module Keeperball
  module Transaction
    class Detail
      include Mongoid::Document
      include Mongoid::Timestamps

      field :player_key, type: String
      field :detail_type, type: String
      field :source, type: String
      field :destination, type: String
      field :cap, type: Integer

      embedded_in :transaction,
        class_name: 'Keeperball::Transaction',
        inverse_of: :transaction_detail

      validates :detail_type, presence: true
      validates :source, presence: true
      validates :destination, presence: true
      validate :player_or_cap
      validate :detail_type_valid

      attr_accessor allowed_detail_types
      self.allowed_detail_types = %w(waiver free_agent trade)

      private

      def detail_type_valid
        self.allowed_detail_types.include?(detail_type)
      end

      def player_or_cap
        player.present? || cap.present?
      end
    end
  end
end