# frozen_string_literal: true

require_relative '../../lib/config'
require_relative '../../lib/senzing'

RSpec.describe Senzing do
  subject(:senzing) { described_class.new(config) }

  let(:client) { instance_double(Faraday::Connection).tap { |c| allow(c).to receive(:put) } }
  let(:senzing_config) { { data_source: 'RSPEC', tls: false } }

  let(:config) do
    Config.new do |c|
      c.senzing.merge!(senzing_config)
    end
  end

  before do
    allow(Faraday).to receive(:new).and_return(client)
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
      senzing.upsert_record(record)
      expect(client).to have_received(:put)
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
