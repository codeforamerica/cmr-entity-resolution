# frozen_string_literal: true

module Filter
  # Base class for filters.
  class Base
    def initialize(filter_config = {})
      @filter_config = defaults.merge(filter_config)
    end

    # Returns the configuration for the current filter.
    #
    # @return [Hash]
    def config
      @filter_config
    end

    # Apply the filter to a record to determine if it should be kept.
    #
    # @param record [CSV::ROW] The record to apply the filter to.
    # @return [Boolean] Whether or not the record should be kept.
    #
    # @raise NotImplementedError
    def filter(record)
      raise NotImplementedError, 'Base class does not have a filter.'
    end

    private

    # Define default configuration values.
    #
    # @return [Hash]
    def defaults
      {}
    end
  end
end
