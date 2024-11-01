# frozen_string_literal: true

require_relative 'database'

module Source
  # MySQL source for data imports.
  class MySQL < Database
    private

    def defaults
      super.merge({ adapter: :mysql2, port: 3306, security: nil })
    end
  end
end
