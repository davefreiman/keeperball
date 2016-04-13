module Keeperball
  class Roster
    include Mongoid::Document
    include Mongoid::Timestamps

    field :team_key, type: String
    field :user_id, type: Integer
    field :name, type: String

    belongs_to :user, inverse_of: :rosters
    has_many :players, class_name: 'Keeperball::Player'
  end
end