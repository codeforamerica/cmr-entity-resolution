# frozen_string_literal: true

module Transformation
  # Base class for transformations.
  class Base
    def initialize(transform_config = {})
      @transform_config = defaults.merge(transform_config)
    end

    # Returns the configuration for the current transformation.
    #
    # @return [Hash]
    def config
      @transform_config
    end

    # Apply the transformation to a record to determine.
    #
    # @param record [CSV::ROW] The record to transform.
    # @return [Boolean] Whether or not the record was modified.
    #
    # @raise NotImplementedError
    def transform(record)
      raise NotImplementedError, 'Base class does not have a transformation.'
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
