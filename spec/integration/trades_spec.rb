require 'rails_helper'

describe TradesController do
  describe '#GET index' do
    before do
      get trades_url
    end

    it 'returns 200' do
      expect(response.status).to eq 200
    end
  end

  describe '#POST create' do

  end

  describe '#PUT accept' do

  end

  describe '#PUT decline' do

  end

  describe '#GET pickups' do
    before do
      get trades_url
    end
    it 'returns 200' do
      expect(response.status).to eq 200
    end
  end
end
