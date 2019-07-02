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

      def pickup_details_for_display
        return unless move_type == 'add'

        details.each_with_object({}) do |detail, hash|
          if detail.detail_type == 'add'
            hash[detail.destination_team.name] ||= []
            hash[detail.destination_team.name] << detail.piece_moved_name
          else
            hash[detail.destination.capitalize] ||= []
            hash[detail.destination.capitalize] << detail.piece_moved_name
          end
        end
      end

      def pickup_type
        details.find_by(detail_type: 'add').source.capitalize
      rescue Mongoid::Errors::DocumentNotFound => _e
        'Straight Drop'
      end

      def formatted_completed_date
        completed_at.strftime('%B %d, %Y - %m:%M %p ')
      end
    end
  end
end
