module Keeperball
  module YahooApi
    module Builder
      class Player < Base
        attr_accessor :path

        def build(start = 0)
          api_url + 'league/' + league_id + '/players;start=' + start.to_s
        end
      end
    end
  end
end
