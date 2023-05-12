# frozen_string_literal: true

require_relative 'base'

module Source
  # File source for importing data.
  class File < Base
    private

    # Opens the file and acts as a proxy for method calls.
    #
    # @return [::File]
    def file
      @file ||= ::File.open(@source_config[:path], 'r')
    end
  end
end
