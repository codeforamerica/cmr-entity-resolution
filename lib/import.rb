# frozen_string_literal: true

require_relative 'filter'
require_relative 'senzing'
require_relative 'source'

# Imports data from a configured destination into Senzing.
class Import
  # Instantiate a new import object.
  #
  # @param config [Config]
  def initialize(config)
    @config = config
  end

  # Import records from a configured source into Senzing.
  def import
    source.each do |record|
      next unless filter(record)

      senzing.upsert_record(record)
    end
  end

  private

  # Apply filters to a record
  #
  # @param record [Hash] The record to apply filters to.
  # @return [Boolean] Whether or not the record should be included.
  def filter(record)
    Filter.filter(@config, record)
  end

  # Loads the Senzing client and proxies calls.
  #
  # @return [Senzing]
  def senzing
    @senzing ||= Senzing.new(@config)
  end

  # Loads the appropriate destination to proxy calls.
  #
  # @return [Source::Base]
  def source
    @source ||= Source.from_config(@config.source)
  end
end
