# frozen_string_literal: true

require 'csv'

module API
  module Parser
    # Parser for CSV requests to the API.
    class CSV
      def self.call(object, _env)
        ::CSV.parse(object, headers: true, strip: true).first.to_h
      end
    end
  end
end
