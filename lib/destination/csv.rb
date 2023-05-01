# frozen_string_literal: true

require 'csv'
require 'iteraptor'

require_relative 'file'

module Destination
  # CSV file destination for exported data.
  class CSV < File
    private

    def defaults
      super.merge(headers: [])
    end

    def file
      @file ||= ::CSV.open(@destination_config[:path], file_mode,
                           write_headers: true, headers: @destination_config[:headers])
    end

    def format_entity(entity)
      entity.iteraptor.flatten.values
    end
  end
end
