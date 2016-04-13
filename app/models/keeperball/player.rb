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
  end
end