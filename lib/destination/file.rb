# frozen_string_literal: true

require_relative 'base'

module Destination
  # File destination for exported data.
  class File < Base
    def add_record(entity)
      file.puts(format_entity(entity))
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

    # Formats the entity to an appropriate string to be written to the file.
    #
    # @return [String]
    def format_entity(entity)
      entity.to_s
    end
  end
end
