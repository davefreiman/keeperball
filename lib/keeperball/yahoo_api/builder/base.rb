module Keeperball
  module YahooApi
    module Builder
      class Base
        def build
          raise NotImplementedError
        end

        private

        def api_url
          'http://fantasysports.yahooapis.com/fantasy/v2/'
        end

        def league_id
          Keeperball::Application.config.keeper_league_id[
            Keeperball::Application.config.current_year
          ]
        end
      end
    end
  end
end
