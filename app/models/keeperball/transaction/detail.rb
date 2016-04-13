module Keeperball
  module Transaction
    class Detail
      include Mongoid::Document
      include Mongoid::Timestamps

      field :player_key, type: String
      field :detail_type, type: String
      field :source, type: String
      field :destination, type: String
      field :cap, type: Integer

      embedded_in :transaction,
        class_name: 'Keeperball::Transaction',
        inverse_of: :transaction_detail
    end
  end
end