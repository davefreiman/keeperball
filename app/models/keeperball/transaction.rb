module Keeperball
  class Transaction
    include Mongoid::Document
    include Mongoid::Timestamps

    field :move_type, type: String
    field :transaction_key, type: String
    field :completed_at, type: DateTime

    embeds_many :transaction_details,
      class_name: 'Keeperball::Transaction::Detail'
  end
end