# frozen_string_literal: true

require_relative 'source/csv'
require_relative 'source/informix'

# Helper methods for loading sources.
module Source
  class InvalidSource < RuntimeError; end

  # Load a source based on the configuration.
  #
  # @param source_config [Hash] Source configuration.
  # @return [Source::Base]
  #
  # @raise [InvalidSource] When the source type can not be found.
  def self.from_config(source_config)
    Object.const_get("Source::#{source_config[:type]}").new(source_config)
  rescue NameError
    raise InvalidSource, "Unknown source type #{source_config[:type]}"
  end
end
