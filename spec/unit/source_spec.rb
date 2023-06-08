# frozen_string_literal: true

require_relative '../../lib/config'
require_relative '../../lib/source'

RSpec.describe Source do
  let(:config) { build(:config, sources: source_config) }
  let(:source_config) { [{ type: 'CSV' }] }

  describe '.from_config' do
    subject(:concrete) { described_class.from_config(config.sources.first) }

    context 'when a valid destination type is provided' do
      it 'returns the proper destination' do
        expect(concrete).to be_a(Source::CSV)
      end
    end

    context 'when an invalid destination type is provided' do
      let(:source_config) { [{ type: 'Invalid' }] }

      it 'raises an exception' do
        expect { concrete }.to raise_error(Source::InvalidSource)
      end
    end
  end
end
