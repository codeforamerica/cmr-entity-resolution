# frozen_string_literal: true

require_relative '../../lib/config'
require_relative '../../lib/destination'

RSpec.describe Destination do
  let(:config) { build(:config, destination: destination_config) }
  let(:destination_config) { { type: 'CSV' } }

  describe '.from_config' do
    subject(:concrete) { described_class.from_config(config.destination) }

    context 'when a valid destination type is provided' do
      it 'returns the proper destination' do
        expect(concrete).to be_a(Destination::CSV)
      end
    end

    context 'when an invalid destination type is provided' do
      let(:destination_config) { { type: 'Invalid' } }

      it 'raises an exception' do
        expect { concrete }.to raise_error(Destination::InvalidDestination)
      end
    end
  end
end
