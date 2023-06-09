# frozen_string_literal: true

require_relative 'filter/non_human'
require_relative 'filter/value_is'

# Filter records during processing.
module Filter
  class InvalidFilter < RuntimeError; end

  # Pass a record through all configured filters to determine if it should be
  # kept.
  #
  # @param config [Config] Configuration object.
  # @param record [Hash] The record to filter.
  # @return [Boolean] Whether or not this record should be included.
  def self.filter(config, record)
    result = config.filters.all? do |filter|
      filter_from_config(filter).filter(record)
    end

    config.logger.info("Filtering out record #{record[:RECORD_ID]}") unless result

    result
  end

  # Load a filter based on the defined configuration.
  #
  # @param filter_config [Hash|String] The name of a filter or a configuration
  #   hash for one.
  # @return [Filter::Base]
  #
  # @raise [InvalidFilter] When the filter can not be found.
  def self.filter_from_config(filter_config)
    return Object.const_get("Filter::#{filter_config}").new unless filter_config.is_a?(Hash)

    Object.const_get("Filter::#{filter_config[:filter]}").new(filter_config)
  rescue NameError
    type = filter_config.is_a?(Hash) ? filter_config[:filter] : filter_config
    raise InvalidFilter, "Unknown filter type #{type}"
  end
end
