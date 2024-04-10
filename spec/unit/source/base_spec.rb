# frozen_string_literal: true

require_relative '../../../lib/source/base'

describe Source::Base do
  subject(:source) { described_class.new(config) }

  let(:config) { {} }

  describe '#each' do
    it 'raises an exception' do
      expect { source.each }.to raise_error(NotImplementedError)
    end
  end

  describe '#name' do
    context 'when no name was specified' do
      it 'uses the class name' do
        expect(source.name).to eq('Base')
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
