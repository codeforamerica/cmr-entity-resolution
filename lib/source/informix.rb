# frozen_string_literal: true

require_relative 'database'

module Source
  # Informix source for data imports.
  class Informix < Database
    private

    def defaults
      super.merge({ adapter: :ibmdb, port: 9089, security: nil })
    end
  end
end
