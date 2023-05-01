# frozen_string_literal: true

module Destination
  # Base class for destinations.
  class Base
    def initialize(destination_config = {})
      @destination_config = defaults.merge(destination_config)
    end

    # Adds an entity to the destination.
    #
    # @param entity ??????
    #
    # @raise NotImplementedError
    def add_record(entity)
      raise NotImplementedError, 'Base class should be be instantiated.'
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
