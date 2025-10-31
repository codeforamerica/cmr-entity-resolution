# frozen_string_literal: true

require_relative 'filterable'
require_relative 'senzing'
require_relative 'source'
require_relative 'transformable'

# Imports data from a configured destination into Senzing.
class Import
  include Filterable
  include Transformable

  class SourceNotFound < RuntimeError; end

  # Instantiate a new import object.
  #
  # @param config [Config]
  def initialize(config)
    @config = config
  end

  # Import records from all configured sources into Senzing.
  #
  # @return boolean Whether all records were imported successfully.
  def import
    sources.map { |name, _| import_from(name) }.all?(true)
  end

  # Import records from a single source into Senzing.
  #
  # @param source_name [String|Symbol] The name of the source to import from.
  # @return boolean Whether all records were imported successfully.
  def import_from(source_name)
    raise SourceNotFound, "#{source_name} not found" unless @config.sources.key?(source_name)

    success = true
    source = sources[source_name]
    @config.logger.info("Importing data from #{source.name}")
    source.each do |record|
      next unless filter(record)

      success &&= senzing.upsert_record(transform(source, record))
    end

    success
  end

  private

  # Loads the Senzing client and proxies calls.
  #
  # @return [Senzing]
  def senzing
    @senzing ||= Senzing.new(@config)
  end

  # Loads all configured sources.
  #
  # @yield
  # @yieldparam [Source::Base] A source object for data imports.
  #
  # @return [Hash<Symbol, Source::Base>]
  def sources
    @sources ||= @config.sources.to_h do |name, source|
      source[:name] ||= name

      loaded = Source.from_config(source)
      yield loaded if block_given?

      [name, loaded]
    end
  end
end
