# frozen_string_literal: true

require 'csv'
require 'sequel'
require_relative 'file'

module Source
  # MySQL source for data imports.
  class MySQL < Base
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
        adapter: 'mysql2',
        host: @source_config[:host],
        database: @source_config[:database],
        port: @source_config[:port],
        user: @source_config[:username],
        password: @source_config[:password],
        schema: @source_config[:schema] || @source_config[:username],
        security: @source_config[:security]
      )
    end

    def defaults
      super.merge({ port: 3306, security: nil })
    end
  end
end
