module Keeperball
  module YahooApi
    module Builder
      class Transaction < Base
        attr_accessor :path

        def build
          api_url + 'league/' + league_id + '/transactions'
        end

      end
    end
  end
end
