require 'rails_helper'

module Keeperball
  describe Player do
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
