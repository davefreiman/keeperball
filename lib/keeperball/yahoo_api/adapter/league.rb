module Keeperball
  module YahooApi
    module Adapter
      class League < Base
        def endpoint
          'http://fantasysports.yahooapis.com/fantasy/v2/league/' + type.to_s
        end

        def type
          '353.l.61815'
        end
      end
    end
  end
end
