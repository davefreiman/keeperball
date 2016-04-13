module Keeperball
  module Import
    class Base
      attr_reader :document

      def initialize(document)
        @document = document
      end

      def ingest
        raise NotImplementedError
      end
    end
  end
end