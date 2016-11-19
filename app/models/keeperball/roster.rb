module Keeperball
  class Roster
    include Mongoid::Document
    include Mongoid::Timestamps
    include Seasonable

    field :team_key, type: String
    field :name, type: String
    field :season, type: Integer
    field :cap_map, type: Hash, default: {}

    belongs_to :user, inverse_of: :rosters
    has_many :players, class_name: 'Keeperball::Player'

    validates :team_key, presence: true, uniqueness: true
    validates :name, presence: true
    before_validation :default_cap_map

    def self.find_by_key(key)
      Keeperball::Roster.where(team_key: key).first
    end

    def next_year_cap
      self.cap_map[next_year]
    end

    def set_next_year_cap(value)
      self.cap_map[next_year] = value
      save
    end

    private

    def self.yahoo_reference_key
      :team_key
    end

    def default_cap_map
      return if cap_map.has_key?(next_year)
      self.cap_map[next_year] = 180
    end

    def next_year
      (Keeperball::Application.config.current_year + 1).to_s
    end
  end
end
