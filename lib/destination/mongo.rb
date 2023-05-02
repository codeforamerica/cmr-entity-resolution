# frozen_string_literal: true

require 'mongo'
require_relative 'base'

module Destination
  # Mongo database destination for exported data.
  class Mongo < Base
    def add_record(record)
      collection = client[@destination_config[:collection]]
      collection.insert_one(record)
    end

    private

    # Connects to the database and acts as a proxy for method calls.
    #
    # @return [::Mongo::Client]
    def client
      @client ||= ::Mongo::Client.new(@destination_config[:hosts],
                                      password: @destination_config[:password],
                                      user: @destination_config[:username],
                                      ssl: false)
                                 .use(@destination_config[:database])
    end

    # Define default configuration values.
    #
    # @return [Hash]
    def defaults
      {}
    end
  end
end
