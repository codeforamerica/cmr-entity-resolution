# frozen_string_literal: true

require_relative '../../../../lib/source/api/base'

describe Source::API::Base do
  subject(:source) { described_class.new(config) }

  let(:config) { { type: 'API::Base', payload: } }
  let(:payload) { [{ id: 'rspec-0' }, { id: 'rspec-1' }] }

  describe '#each' do
    context 'when the payload is an array' do
      it 'yields each record' do
        expect { |b| source.each(&b) }.to yield_successive_args(*payload)
      end
    end

    context 'when the payload is not an array' do
      let(:payload) { { id: 'rspec-3' } }

      it 'yields for the single record' do
        expect { |b| source.each(&b) }.to yield_with_args(payload)
      end
    end
  end

  describe '#name' do
    context 'when no name was specified' do
      it 'uses the class name' do
        expect(source.name).to eq('API::Base')
      end
    end

    context 'when a name was specified' do
      let(:config) { { name: 'specified' } }

      it 'uses the specified name' do
        expect(source.name).to eq('specified')
      end
    end
  end
end
