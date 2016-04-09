module Keeperball
  module YahooApi
    module Adapter
      class Base
        attr_reader :access_token

        def initialize(access_token)
          @access_token = access_token
        end

        def do_request
          access_token.get(endpoint)
        end

        def endpoint
          Raise NotImplementedError('You need to extend the base class')
        end
      end
    end
  end
end
