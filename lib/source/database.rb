# frozen_string_literal: true

require 'sequel'
require_relative 'base'

module Source
  # Basic database source for data imports. Should be extended by specific
  # database implementations.
  class Database < Base
    def each
      table = db[@source_config[:table].to_sym]
      table.each do |record|
        record.transform_keys! { |key| field_mapper(key) }
        yield record
      end
    end

    private

    # Establishes a database connection and proxies calls to the database.
    #
    # @return [Sequel::Database]
    def db
      @db ||= Sequel.connect(
        adapter: @source_config[:adapter],
        host: @source_config[:host],
        database: @source_config[:database],
        port: @source_config[:port],
        user: @source_config[:username],
        password: @source_config[:password],
        schema: @source_config[:schema] || @source_config[:username],
        security: @source_config[:security]
      )
    end
  end
end
