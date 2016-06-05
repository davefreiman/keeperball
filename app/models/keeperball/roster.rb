module Keeperball
  class Roster
    include Mongoid::Document
    include Mongoid::Timestamps

    field :team_key, type: String
    field :name, type: String
    field :season, type: Integer

    belongs_to :user, inverse_of: :rosters
    has_many :players, class_name: 'Keeperball::Player'

    validates :team_key, presence: true, uniqueness: true
    validates :name, presence: true

    def self.find_by_key(key)
      Keeperball::Roster.where(team_key: key).first
    end
  end
end
