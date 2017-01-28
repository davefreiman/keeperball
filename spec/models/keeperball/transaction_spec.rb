require 'rails_helper'

module Keeperball
  describe Transaction do
    let(:built_details) do
      [
        {
          destination: '123123',
          source: '123123',
          detail_type: 'trade',
          cap: 0
        }
      ]
    end

    it_should_behave_like Seasonable, {
      move_type: 'add', details: [
        {
          destination: '123123',
          source: '123123',
          detail_type: 'trade',
          cap: 0
        }
      ]
    }

    describe 'validations' do
      it 'ensures the move passed is valid' do
        transaction = Keeperball::Transaction.new(
          transaction_key: '364.validkey',
          move_type: 'baseball',
          details: built_details
        )

        expect(transaction.save).to be false

        transaction.move_type = 'add'
        expect(transaction.save).to be true

        transaction.details = []
        expect(transaction.save).to be false
      end
    end

    describe '.from_season' do
      it 'loads only transactions from a specific season' do

        Keeperball::Transaction.create(
          transaction_key: '353.validkey',
          move_type: 'add',
          completed_at: DateTime.parse('2015-11-11'),
          details: built_details
        )
        Keeperball::Transaction.create(
          transaction_key: '364.validkey2',
          move_type: 'add',
          completed_at: DateTime.parse('2016-11-11'),
          details: built_details
        )
        Keeperball::Transaction.create(
          transaction_key: '364.validkey3',
          move_type: 'add',
          completed_at: DateTime.parse('2017-03-11'),
          details: built_details
        )

        expect(Keeperball::Transaction.from_season(2016).count).to eq 1
        expect(Keeperball::Transaction.from_season(2017).count).to eq 2
      end
    end

    describe '.unprocessed' do
      it 'pulls in transactions that haven\'t been processed' do
        Keeperball::Transaction.create(
          transaction_key: '364.validkey',
          move_type: 'add',
          completed_at: DateTime.parse('2016-11-11'),
          details: built_details
        )
        Keeperball::Transaction.create(
          transaction_key: '364.validkey2',
          move_type: 'add',
          completed_at: DateTime.parse('2016-11-11'),
          processed: true,
          details: built_details
        )

        expect(Keeperball::Transaction.unprocessed.count).to eq 1
      end
    end
  end
end
