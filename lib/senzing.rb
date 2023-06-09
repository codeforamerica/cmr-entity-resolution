# frozen_string_literal: true

require 'faraday'

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
  end

  private

  # Loads the client used for API requests and proxies calls.
  #
  # @return [Faraday::Connection]
  def client
    @client ||= Faraday.new(url) do |conn|
      conn.request :json
      conn.response :json, parser_options: { symbolize_names: true }
    end
  end

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
