module Keeperball
  module YahooApi
    module Builder
      class Base
        def build
          raise NotImplementedError
        end

        private

        def api_url
          'https://fantasysports.yahooapis.com/fantasy/v2/'
        end

        def league_id
          Keeperball::Application.config.yahoo_league_ids[
            Keeperball::Application.config.current_year
          ]
        end
      end
    end
  end
end
