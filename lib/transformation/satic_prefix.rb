# frozen_string_literal: true

require_relative 'base'

module Transformation
  # Sets a static prefix to another value.
  class StaticPrefix < Base
    def transform(record)
      current = record[@transform_config[:field].to_sym] || nil
      destination = @transform_config[:destination] || @transform_config[:field]

      value = "#{@transform_config[:prefix]}#{current}" if current || !@transform_config[:if_not_empty]
      record[destination.to_sym] = value || nil
    end

    private

    def defaults
      super.merge({ if_not_empty: true })
    end
  end
end
