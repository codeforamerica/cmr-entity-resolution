# frozen_string_literal: true

require_relative 'filter'

# Helper module that adds transformation support.
module Filterable
  # Apply filters to a record
  #
  # @param record [Hash] The record to apply filters to.
  # @return [Boolean] Whether or not the record should be included.
  def filter(record)
    Filter.filter(@config, record)
  end
end
