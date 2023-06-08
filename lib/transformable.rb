# frozen_string_literal: true

require_relative 'transformation'

# Helper module that adds transformation support.
module Transformable
  # Apply transformations to a record
  #
  # @param context [Source::Base|Destination::Base] Context (source or destination) for the record.
  # @param record [Hash] The record to be transformed.
  # @return [Hash]
  def transform(context, record)
    Transformation.transform(@config, record, context.config[:transformations])
  end
end
