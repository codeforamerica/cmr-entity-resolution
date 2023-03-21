# frozen_string_literal: true

require_relative 'base'

module Transformation
  # Sets a static value into a field.
  class StaticValue < Base
    def transform(record)
      current = record[@transform_config[:field]] || nil

      record[@transform_config[:field].to_sym] = @transform_config[:value]

      # Only return true if we changed the field's value.
      current != @transform_config[:value]
    end
  end
end
