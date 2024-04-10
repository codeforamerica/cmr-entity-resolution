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
  def import
    sources.each_key { |name| import_from(name) }
  end

  # Import records from a single source into Senzing.
  #
  # @param source_name [String|Symbol] The name of the source to import from.
  def import_from(source_name)
    raise SourceNotFound, "#{source_name} not found" unless @config.sources.key?(source_name)

    source = sources[source_name]
    @config.logger.info("Importing data from #{source.name}")
    source.each do |record|
      next unless filter(record)

      senzing.upsert_record(transform(source, record))
    end
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
