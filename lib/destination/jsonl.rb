# frozen_string_literal: true

require_relative 'file'

module Destination
  # JSON Lines file destination for exported data.
  class JSONL < File
    private

    def format_entity(entity)
      entity.to_json
    end
  end
end
