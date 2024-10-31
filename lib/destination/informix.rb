# frozen_string_literal: true

require_relative 'database'

module Destination
  # Informix destination for data exports.
  class Informix < Database
    private

    def defaults
      super.merge({ adapter: :ibmdb, port: 9089, security: nil })
    end
  end
end
