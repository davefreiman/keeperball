module Keeperball
  module YahooApi
    module Builder
      class Roster < Base
        attr_accessor :path

        def build
          api_url + 'league/' + league_id + '/teams'
        end
      end
    end
  end
end
