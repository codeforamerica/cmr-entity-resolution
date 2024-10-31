# frozen_string_literal: true

require 'sequel'
require_relative 'base'

module Destination
  # Basic database destination for data exports. Should be extended by specific
  # database implementations.
  class Database < Base
    # TODO: Add support for databases that don't support REPLACE.
    def add_record(record)
      table = db[@destination_config[:table].to_sym]
      table.replace(record)
    end

    private

    # Establishes a database connection and proxies calls to the database.
    #
    # @return [Sequel::Database]
    def db
      @db ||= Sequel.connect(
        adapter: @destination_config[:adapter],
        host: @destination_config[:host],
        database: @destination_config[:database],
        port: @destination_config[:port],
        user: @destination_config[:username],
        password: @destination_config[:password],
        schema: @destination_config[:schema] || @destination_config[:username],
        security: @destination_config[:security]
      )
    end

    def upsert(record)
      raise NotImplementedError, "No upsert query defined for #{@destination_config.type}"
    end
  end
end
