module Keeperball
  module ViewModels
    module TransactionViewModel
      extend ActiveSupport::Concern

      def details_for_display
        return unless move_type == 'trade'
        details.each_with_object({}) do |detail, hash|
          hash[detail.destination_team.name] ||= []
          hash[detail.destination_team.name] << detail.piece_moved_name
        end
      end

      def formatted_completed_date
        completed_at.strftime('%B %d, %Y - %m:%M %p ')
      end
    end
  end
end
