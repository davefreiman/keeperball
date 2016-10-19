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
      inverse_of: :details

    validates :detail_type, presence: true
    validates :source, presence: true
    validates :destination, presence: true
    validate :player_or_cap
    validate :detail_type_valid

    cattr_accessor :allowed_detail_types
    self.allowed_detail_types = %w(drop add trade)

    def piece_moved
      @piece_moved ||=
        Keeperball::Player.find_by_key(player_key).presence || cap.presence
    end

    def piece_moved_name
      return "$#{piece_moved.to_s} cap" if cap.present?
      piece_moved.name
    end

    def destination_team
      Keeperball::Roster.find_by_key(destination)
    end

    def source_team
      Keeperball::Roster.find_by_key(source)
    end

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
