# frozen_string_literal: true

require_relative '../../lib/config'

RSpec.describe Config do
  describe '#initialize' do
    it 'can be initialized without a block' do
      expect(described_class.new).to be_a(described_class)
    end

    it 'can be initialized with a block' do
      expect { |probe| described_class.new(&probe) }.to yield_with_args(described_class)
    end
  end

  describe '.from_file' do
    subject(:from_file) { described_class.from_file(path) }

    let(:path) { File.join(__dir__, '../../config/config.sample.yml') }

    it 'can be loaded from a file' do
      expect(from_file).to be_a(described_class)
    end

    it 'loads expected options' do
      expect(from_file.sources).to include(:import)
    end
  end

  describe '#defaults' do
    describe 'concurrency' do
      it 'defaults to 4' do
        expect(described_class.new.concurrency).to eq(4)
      end

      it 'uses IMPORT_CONCURRENCY env variable' do
        allow(ENV).to receive(:fetch).with('IMPORT_CONCURRENCY', anything).and_return('16')

        expect(described_class.new.concurrency).to eq(16)
      end
    end
  end
end
