# frozen_string_literal: true

require_relative '../base'

module Source
  module API
    # Base class for API data sources.
    class Base < Source::Base
      def each
        records = @source_config[:payload].is_a?(Array) ? @source_config[:payload] : [@source_config[:payload]]
        records.each do |row|
          row.transform_keys! { |key| field_mapper(key) }
          yield row
        end
      end

      private

      def default_name
        "API::#{super}"
      end
    end
  end
end
