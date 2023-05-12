# frozen_string_literal: true

require 'csv'
require_relative 'file'

module Source
  # CSV file source for data imports
  class CSV < File
    def each
      file.header_convert(&method(:field_mapper))
      file.each do |row|
        yield row.to_hash
      end
    end

    private

    # @return [::CSV]
    def file
      @file ||= ::CSV.open(@source_config[:path], 'r', headers: true, strip: true)
    end
  end
end
