# frozen_string_literal: true

require 'rack/test'

require_relative '../../../lib/api/api'

describe API::API do
  include Rack::Test::Methods

  def app
    API::API
  end

  let(:api_key) { 'VALID' }

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('CMR_API_KEY', anything).and_return('VALID')
  end

  describe 'GET /health' do
    it 'returns 200' do
      get '/health'
      expect(last_response.status).to eq(200)
    end

    it 'includes a status message' do
      get '/health'
      expect(last_response.body).to eq({ status: 'ok' }.to_json)
    end
  end

  # TODO: Write tests for a valid source.
  describe 'POST /import' do
    context 'with an invalid API key' do
      let(:api_key) { 'INVALID' }

      it 'returns 401' do
        header 'Authorization', api_key
        post '/import', { source: 'valid' }

        expect(last_response.status).to eq(401)
      end
    end

    context 'with an invalid source' do
      it 'returns 404' do
        header 'Authorization', api_key
        post '/import', { source: 'invalid' }

        expect(last_response.status).to eq(404)
      end

      it 'includes a message' do
        header 'Authorization', api_key
        post '/import', { source: 'invalid' }

        expect(last_response.body).to \
          eq({ status: 'error', message: 'Source "invalid" not found.' }.to_json)
      end
    end
  end
end
