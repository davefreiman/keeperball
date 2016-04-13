require 'rails_helper'

module Keeperball
  describe Transaction do
    describe 'validations' do
      it 'ensures the move passed is valid' do
        transaction = Keeperball::Transaction.new(
          transaction_key: 'validkey',
          move_type: 'baseball'
        )

        expect(transaction.save).to be false

        transaction.move_type = 'add'
        expect(transaction.save).to be true
      end
    end
  end
end
