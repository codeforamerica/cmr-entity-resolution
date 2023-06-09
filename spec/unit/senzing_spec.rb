# frozen_string_literal: true

require_relative '../../lib/config'
require_relative '../../lib/senzing'

RSpec.describe Senzing do
  subject(:senzing) { described_class.new(config) }

  let(:senzing_config) { { data_source: 'RSPEC', tls: false } }
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:client) do
    Faraday.new { |b| b.adapter(:test, stubs) }
  end

  let(:config) do
    build(:config, senzing: senzing_config)
  end

  before do
    allow(Faraday).to receive(:new).and_return(client).and_yield(client)
  end

  describe '#initialize' do
    it 'applies defaults to the config' do
      expect(senzing.config.senzing[:host]).to eq('localhost')
    end

    it 'does not override configs with defaults' do
      expect(senzing.config.senzing[:data_source]).to eq('RSPEC')
    end
  end

  describe '#upsert_record' do
    let(:record) { { RECORD_ID: '1234' } }

    it 'writes the records to Senzing' do
      stubs.put('/data-sources/RSPEC/records/1234') { [200, {}, ''] }
      expect(client).to receive(:put).and_call_original

      senzing.upsert_record(record)
      stubs.verify_stubbed_calls
    end
  end

  describe '#client' do
    include_examples 'proxy method', :client, Faraday do
      let(:object) { client }
    end
  end

  describe '#url' do
    subject(:url) { URI(senzing.send(:url)) }

    let(:senzing_config) { super().merge(host: 'rspec', port: 1234) }

    it 'returns the expected host' do
      expect(url.host).to eq(senzing_config[:host])
    end

    it 'returns the expected port' do
      expect(url.port).to eq(senzing_config[:port])
    end

    context 'when TLS is enabled' do
      let(:senzing_config) { super().merge(tls: true) }

      it 'returns the expected scheme' do
        expect(url.scheme).to eq('https')
      end
    end

    context 'when TLS is disabled' do
      let(:senzing_config) { super().merge(tls: false) }

      it 'returns the expected scheme' do
        expect(url.scheme).to eq('http')
      end
    end
  end
end
