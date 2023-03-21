# frozen_string_literal: true

require_relative 'base'

module Transformation
  # Split a value into parts and store those parts in other fields.
  class SplitValue < Base
    def transform(record)
      # Keep a copy of the original record so we can determine if it has been
      # modified.
      original = record.clone

      parts = record[@transform_config[:field].to_sym].split(@transform_config[:delimiter])
      @transform_config[:parts].each do |index, destination|
        record[destination.to_sym] = parts[index]
      end

      record != original
    end

    private

    def defaults
      super.merge({
                    delimiter: ',',
                    parts: {}
                  })
    end
  end
end
