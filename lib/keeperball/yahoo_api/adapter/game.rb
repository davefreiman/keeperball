module Keeperball
  module YahooApi
    module Adapter
      class Game < Base


        def endpoint
          'http://fantasysports.yahooapis.com/fantasy/v2/game/' + type.to_s
        end

        def type
          'nba'
        end
      end
    end
  end
end
