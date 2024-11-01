# frozen_string_literal: true

require_relative 'destination/csv'
require_relative 'destination/mongo'
require_relative 'destination/mysql'
require_relative 'destination/jsonl'

# Helper methods for loading destinations.
module Destination
  class InvalidDestination < RuntimeError; end

  # Load a destination based on the configuration file.
  #
  # @param destination_config [Hash] Destination configuration from the config
  #   file.
  # @return [Destination::Base]
  #
  # @raise [InvalidDestination] When the destination type can not be found.
  def self.from_config(destination_config)
    Object.const_get("Destination::#{destination_config[:type]}").new(destination_config)
  rescue NameError
    raise InvalidDestination, "Unknown destination type #{destination_config[:type]}"
  end
end
