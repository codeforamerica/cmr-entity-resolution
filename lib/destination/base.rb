# frozen_string_literal: true

module Destination
  # Base class for destinations.
  class Base
    # Initialize a new destination.
    #
    # @param destination_config [Hash] Configuration for this destination.
    def initialize(destination_config = {})
      @destination_config = defaults.merge(destination_config)
    end

    # Returns the configuration for the current destination.
    #
    # @return [Hash]
    def config
      @destination_config
    end

    # Adds a record to the destination.
    #
    # @param record [Hash] Record to add to the destination.
    #
    # @raise NotImplementedError
    def add_record(record)
      raise NotImplementedError, 'Base class should not be instantiated.'
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
