# frozen_string_literal: true

require_relative 'base'

module Destination
  # File destination for exported data.
  class File < Base
    def add_record(record)
      file.puts(format_record(record))
    end

    private

    def defaults
      super.merge({ overwrite: false })
    end

    # Opens the file and acts as a proxy for method calls.
    #
    # @return [::File]
    def file
      @file ||= ::File.open(@destination_config[:path], file_mode)
    end

    # Determines the file mode based on configuration settings.
    #
    # @return [String]
    def file_mode
      @destination_config[:overwrite] ? 'w' : 'a'
    end

    # Formats the record to an appropriate string to be written to the file.
    #
    # @param record [Hash] Record to be formatted.
    # @return [String]
    def format_record(record)
      record.to_s
    end
  end
end
