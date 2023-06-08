# frozen_string_literal: true

require_relative 'transformation/satic_prefix'
require_relative 'transformation/split_value'
require_relative 'transformation/static_value'

# Transform records during processing.
module Transformation
  class InvalidTransform < RuntimeError; end

  # Pass a record through all configured transforms.
  #
  # @param config [Config] Configuration object.
  # @param record [Hash] The record to transform.
  # @param transformations [Array<Hash>] Array of transformation configurations.
  # @return [Hash] The resulting record after all transformations have been applied.
  def self.transform(config, record, transformations)
    result = transformations.any? do |transformation|
      transform_from_config(transformation).transform(record)
    end

    config.logger.info("Transformations applied to record #{record[:RECORD_ID]}") if result

    record
  end

  # Load a transformation based on the defined configuration.
  #
  # @param transform_config [Hash|String] The name of a transformation or a
  #   configuration hash for one.
  # @return [Transformation::Base]
  #
  # @raise [InvalidTransform] When the transformation can not be found.
  def self.transform_from_config(transform_config)
    return Object.const_get("Transformation::#{transform_config}").new unless transform_config.is_a?(Hash)

    Object.const_get("Transformation::#{transform_config[:transform]}").new(transform_config)
  rescue NameError
    type = transform_config.is_a?(Hash) ? transform_config[:transform] : filter_config
    raise InvalidTransform, "Unknown transformation type #{type}"
  end
end
