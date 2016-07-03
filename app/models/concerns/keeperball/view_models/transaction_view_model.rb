module Keeperball
  module ViewModels
    module TransactionViewModel
      extend ActiveSupport::Concern

      def trade_for_display
        return unless move_type == 'trade'
        details.each_with_object({}) do |detail, hash|
          hash[detail.destination_team.name] ||= []
          hash[detail.destination_team.name] << detail.piece_moved.name
        end
      end
    end
  end
end
