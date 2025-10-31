# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'

# Client for the Senzing API
class Senzing
  attr_reader :config

  # Instantiates a new Senzing client object.
  #
  # @param config [Config]
  def initialize(config)
    config.senzing = defaults.merge(config.senzing)
    @config = config
  end

  # Inserts a new record or updates an existing record.
  #
  # @param record [Hash] The record to be created or updated.
  def upsert_record(record)
    client.put(
      "data-sources/#{@config.senzing[:data_source]}/records/#{record[:RECORD_ID]}",
      record.to_json
    )

    @config.logger.debug("Upserted record #{record[:RECORD_ID]}")
    true
  rescue Faraday::Error => e
    @config.logger.error("Failed to upsert record #{record[:RECORD_ID]}: #{e.message}")
    false
  end

  private

  # Loads the client used for API requests and proxies calls.
  #
  # @return [Faraday::Connection]
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def client
    @client ||= Faraday.new(url) do |conn|
      conn.request :json
      conn.response :json, parser_options: { symbolize_names: true }
      conn.response :raise_error
      conn.request :retry, {
        max: 2,
        interval: 0.05,
        interval_randomness: 0.5,
        backoff_factor: 2,
        methods: %i[get put post],
        retry_block: lambda do |env:, **|
          request = JSON.parse(env.request_body, symbolize_names: true)
          @config.logger.warn("Retrying import of record #{request[:RECORD_ID]}")
        end,
        exhausted_retries_block: lambda do |env:, **|
          request = JSON.parse(env.request_body, symbolize_names: true)
          @config.logger.error("Failed to import record #{request[:RECORD_ID]} after max retries")
        end
      }
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # Constructs the host URL based on the configuration options.
  #
  # @return [String]
  def url
    "http#{@config.senzing[:tls] ? 's' : ''}://#{@config.senzing[:host]}:#{@config.senzing[:port]}"
  end

  # Defines default configuration options.
  #
  # @return [Hash]
  def defaults
    {
      data_source: 'PEOPLE',
      host: 'localhost',
      port: 8250,
      tls: true
    }
  end
end
