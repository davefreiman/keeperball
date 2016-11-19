require 'rails_helper'

module Keeperball
  describe Player do
    validation_params =  {
      name: 'Jimmy Butler',
      positions: ['SG'],
      salary: '28',
      expiry: 2017,
      contract_type: 'entry'
    }

    it_should_behave_like Seasonable, validation_params

    describe 'validations' do
      it 'ensures the contract type passed is valid' do
        player = Keeperball::Player.new(
          player_key: 'validkey',
          contract_type: 'invalid',
          name: 'Carmelo Anthony',
          positions: %w(SF PF),
          salary: 35,
          expiry: 2018
        )

        expect(player.save).to be false

        player.contract_type = 'entry'
        expect(player.save).to be true
      end
    end
  end
end
