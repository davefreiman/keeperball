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

    describe '.from_season' do
      it 'loads only transactions from a specific season' do
        Keeperball::Transaction.create(
          transaction_key: 'validkey',
          move_type: 'add',
          completed_at: DateTime.parse('2015-11-11')
        )
        Keeperball::Transaction.create(
          transaction_key: 'validkey2',
          move_type: 'add',
          completed_at: DateTime.parse('2014-11-11')
        )
        Keeperball::Transaction.create(
          transaction_key: 'validkey3',
          move_type: 'add',
          completed_at: DateTime.parse('2015-03-11')
        )

        expect(Keeperball::Transaction.from_season(2016).count).to eq 1
        expect(Keeperball::Transaction.from_season(2015).count).to eq 2
      end
    end
  end
end
