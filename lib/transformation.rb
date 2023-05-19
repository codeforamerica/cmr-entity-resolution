# frozen_string_literal: true

require_relative 'transformation/split_value'
require_relative 'transformation/static_value'

# Transform records during processing.
module Transformation
  # Pass a record through all configured transforms.
  #
  # @param config [Config] Configuration object.
  # @param record [CSV::Row] The record to transform.
  # @param transformations [Array<Hash>] Array of transformation configurations.
  # @return [Boolean] Whether or not this record was transformed.
  def self.transform(config, record, transformations)
    result = transformations.any? do |filter|
      transform_from_config(filter).transform(record)
    end

    config.logger.info("Transformations applied to record #{record[:RECORD_ID]}") if result

    result
  end

  # Load a transformation based on the defined configuration.
  #
  # @param transform_config [Hash|String] The name of a transformation or a
  #   configuration hash for one.
  # @return [Transformation::Base]
  def self.transform_from_config(transform_config)
    return Object.const_get("Transformation::#{transform_config}").new unless transform_config.is_a?(Hash)

    Object.const_get("Transformation::#{transform_config[:transform]}").new(transform_config)
  end
end
