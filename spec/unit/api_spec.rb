# frozen_string_literal: true

require 'rack/test'

require_relative '../../lib/api'

describe API do
  include Rack::Test::Methods

  def app
    API
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
    context 'with an invalid source' do
      it 'returns 404' do
        post '/import', { source: 'invalid' }
        expect(last_response.status).to eq(404)
      end

      it 'includes a message' do
        post '/import', { source: 'invalid' }
        expect(last_response.body).to \
          eq({ status: 'error', message: 'Source "invalid" not found.' }.to_json)
      end
    end
  end
end
