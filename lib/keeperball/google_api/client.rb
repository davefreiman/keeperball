module Keeperball
  module GoogleApi
    class Client
      attr_reader :session

      def initialize(session)
        @session = session
      end

      def execute
        raise NotImplementedError
      end
    end
  end
end