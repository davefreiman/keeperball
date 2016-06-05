module Keeperball
  module GoogleApi
    class Client
      attr_reader :session, :sheet_id

      def initialize(session)
        @sheet_id = Keeperball::Application.config.google_sheet_id
        @session = session
      end

      def execute
        raise NotImplementedError
      end

      private

      def current_season
        Keeperball::Application.config.current_year
      end

      def worksheet
        @worksheet ||= spreadsheet.worksheets.select do |ws|
          ws.title == "#{(current_season - 1).to_s}-#{current_season}"
        end.first
      end

      def spreadsheet
        @spreadsheet ||=
          session.spreadsheet_by_key(sheet_id)
      end

      def legend
        @legend ||= begin
          file_path = "#{Rails.root}/data/sheet_index/2015_2016.json"
          file = File.read(file_path)
          JSON.parse(file)
        end
      end
    end
  end
end
