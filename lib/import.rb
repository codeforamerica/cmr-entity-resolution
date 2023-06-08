# frozen_string_literal: true

require_relative 'filterable'
require_relative 'senzing'
require_relative 'source'
require_relative 'transformable'

# Imports data from a configured destination into Senzing.
class Import
  include Filterable
  include Transformable

  # Instantiate a new import object.
  #
  # @param config [Config]
  def initialize(config)
    @config = config
  end

  # Import records from a configured source into Senzing.
  def import
    each_source do |source|
      @config.logger.info("Importing data from #{source.name}")
      source.each do |record|
        next unless filter(record)

        senzing.upsert_record(transform(source, record))
      end
    end
  end

  private

  # Loads the Senzing client and proxies calls.
  #
  # @return [Senzing]
  def senzing
    @senzing ||= Senzing.new(@config)
  end

  # Iterator for configured sources.
  #
  # @yield
  # @yieldparam source [Source::Base] A source object for data imports.
  def each_source
    @sources ||= @config.sources.each do |source|
      yield Source.from_config(source)
    end
  end
end
