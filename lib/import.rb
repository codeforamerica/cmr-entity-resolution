# frozen_string_literal: true

require 'concurrent'
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

    source = sources[source_name]
    @config.logger.info("Importing data from #{source.name} with #{@config.concurrency} threads")

    success = Concurrent::AtomicBoolean.new(true)
    pool = create_thread_pool

    source.each do |record|
      next unless filter(record)

      transformed = transform(source, record)
      pool.post do
        process_record(transformed, success)
      end
    end

    pool.shutdown
    pool.wait_for_termination(60) # timeout after 60 seconds
    success.value
  ensure
    pool&.kill if pool && !pool.shutdown?
  end

  private

  # Process a single record with error handling, catches exceptions
  def process_record(record, success)
    result = senzing.upsert_record(record)
    success.make_false unless result
  rescue StandardError => e
    @config.logger.error("Failed to upsert record: #{e.message}") # log error
    success.make_false
  end

  # Creates a new thread pool for each import_from call
  def create_thread_pool
    Concurrent::ThreadPoolExecutor.new(
      min_threads: @config.concurrency,
      max_threads: @config.concurrency,
      max_queue: @config.concurrency * 2,  # backpressure, bounded queue (2x threads) 
      fallback_policy: :caller_runs        
    )
  end

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

  def create_thread_pool
    threads = (@config.respond_to?(:concurrency) && @config.concurrency) || 5
    Concurrent::FixedThreadPool.new(threads)
  end

  def process_record(record, success)
    begin
      ok = senzing.upsert_record(record)
      success.make_false unless ok
    rescue => e
      @config.logger.error("Error importing record: #{e.class}: #{e.message}")
      success.make_false
    end
  end
end
