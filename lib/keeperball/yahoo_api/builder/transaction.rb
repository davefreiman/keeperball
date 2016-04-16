module Keeperball
  module YahooApi
    module Builder
      class Transaction < Base
        attr_accessor :path

        def build(start = 0)
          api_url + 'league/' + league_id + '/transactions;start=' + start.to_s
        end
      end
    end
  end
end
