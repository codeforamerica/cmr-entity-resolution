# frozen_string_literal: true

require_relative 'source/csv'
require_relative 'source/informix'

# Helper methods for loading sources.
module Source
  # Load a source based on the configuration.
  #
  # @param source_config [Hash] Source configuration.
  # @return [Source::Base]
  def self.from_config(source_config)
    Object.const_get("Source::#{source_config[:type]}").new(source_config)
  end
end
