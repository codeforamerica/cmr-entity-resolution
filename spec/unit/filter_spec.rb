# frozen_string_literal: true

require_relative '../../lib/config'
require_relative '../../lib/filter'

describe Filter do
  let(:config) { build(:config, filters: filter_config) }
  let(:record) { {} }
  let(:filter_config) { [{ filter: 'ValueIs' }] }

  describe '.filter' do
    subject(:result) { described_class.filter(config, record) }

    let(:filter) { instance_double(Filter::ValueIs) }

    before do
      allow(described_class).to receive(:filter_from_config).and_return(filter)
      allow(filter).to receive(:filter).and_return(!filtered)
    end

    context 'when the record is filtered out' do
      let(:filtered) { true }

      it 'returns false' do
        expect(result).to be(false)
      end
    end

    context 'when the record is not filtered out' do
      let(:filtered) { false }

      it 'returns true' do
        expect(result).to be(true)
      end
    end
  end

  describe '.filter_from_config' do
    subject(:concrete) { described_class.filter_from_config(filter_config.first) }

    context 'when a valid filter type is provided' do
      it 'returns the proper filter' do
        expect(concrete).to be_a(Filter::ValueIs)
      end
    end

    context 'when an invalid filter type is provided' do
      let(:filter_config) { [{ filter: 'Invalid' }] }

      it 'raises an exception' do
        expect { concrete }.to raise_error(Filter::InvalidFilter)
      end
    end
  end
end
