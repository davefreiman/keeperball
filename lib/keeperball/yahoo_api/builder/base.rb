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
          '353.l.61815'
        end
      end
    end
  end
end
