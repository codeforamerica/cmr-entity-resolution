# frozen_string_literal: true

require 'faraday'
require_relative 'destination'
require_relative 'transformable'

# Exports data from senzing into a configured destination.
class Export
  include Transformable

  def initialize(config)
    @config = config
  end

  # TODO: Start by getting the exported data from a file until we can export
  # directly via the API.
  def from_file
    File.readlines(@config.destination[:export_file]).each do |line|
      entity = JSON.parse(line, symbolize_names: true)
      entity[:RESOLVED_ENTITY][:RECORDS].each do |record|
        record[:ENTITY_ID] = entity[:RESOLVED_ENTITY][:ENTITY_ID]
        @config.logger.debug("Exporting record: #{record[:ENTITY_ID]}")
        destination.add_record(process_record(record))
      end
    end
  end

  private

  def process_record(record)
    record = transform(destination, record)

    # Map fields.
    output = {}
    @destination.config[:field_map].each do |field, map|
      output[map.to_sym] = record[field]
    end

    output
  end

  # Loads the appropriate destination to proxy calls.
  #
  # @return [Destination::Base]
  def destination
    @destination ||= Destination.from_config(@config.destination)
  end
end
