module Keeperball
  class Roster
    include Mongoid::Document
    include Mongoid::Timestamps

    field :team_key, type: String
    field :name, type: String

    belongs_to :user, inverse_of: :rosters
    has_many :players, class_name: 'Keeperball::Player'

    validates :team_key, presence: true
    validates :name, presence: true
  end
end