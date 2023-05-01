# frozen_string_literal: true

require_relative 'destination/csv'
require_relative 'destination/jsonl'

# Helper methods for loading destinations.
module Destination
  # Load a destination based on the configuration file.
  #
  # @param destination_config [Hash] Destination configuration from the config
  #   file.
  # @return [Destination::Base]
  def self.from_config(destination_config)
    Object.const_get("Destination::#{destination_config[:type]}").new(destination_config)
  end
end
