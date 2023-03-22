# frozen_string_literal: true

require_relative 'base'

module Filter
  # Filters out records where a field does not match a value.
  class ValueIs < Base
    # Apply the filter to a record to determine if it should be kept.
    #
    # @param record [CSV::ROW] The record to apply the filter to.
    # @return [Boolean] Whether or not the record should be kept.
    def filter(record)
      operator = @filter_config[:inverse] ? :!= : :==
      record[@filter_config[:field].to_sym].public_send(operator, @filter_config[:value])
    end

    private

    def defaults
      super.merge({ inverse: false })
    end
  end
end
