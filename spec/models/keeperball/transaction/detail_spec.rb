require 'rails_helper'

module Keeperball
  describe Transaction::Detail do
    describe 'validations' do
      it 'ensures the detail type passed is valid' do
        transaction = Keeperball::Transaction.new(
          transaction_key: 'validkey',
          move_type: 'add'
        )
        detail = transaction.details.new(
          detail_type: 'drop',
          source: 'Shisland',
          destination: 'waivers'
        )

        expect(transaction.save).to be false

        detail.detail_type = 'invalid'
        detail.player_key = 'dummykey'
        expect(transaction.save).to be false

        detail.detail_type = 'drop'
        expect(transaction.save).to be true
      end
    end
  end
end
