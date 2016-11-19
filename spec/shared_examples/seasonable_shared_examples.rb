module Keeperball
  shared_examples_for Seasonable do |params|
    describe 'default scope' do
      subject { described_class.new(params) }
      it 'should only pull examples from the current season' do
        subject.update_attributes(described_class.yahoo_reference_key => '364.validkey')
        described_class.create(params.merge(described_class.yahoo_reference_key => '353.validkey'))

        expect(described_class.count).to eq 1
        expect(described_class.first).to eq subject
      end
    end

    describe '.from_season' do
      subject { described_class.new(params) }
      it 'should only pull examples from the provided season' do
        subject.update_attributes(described_class.yahoo_reference_key => '353.validkey')
        described_class.create(params.merge(described_class.yahoo_reference_key => '364.validkey'))

        expect(described_class.from_season(2016).count).to eq 1
        expect(described_class.from_season(2016).first).to eq subject
      end
    end
  end
end