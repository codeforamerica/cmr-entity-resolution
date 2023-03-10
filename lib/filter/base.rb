# frozen_string_literal: true

module Filter
  # Base class for filters.
  class Base
    def initialize(filter_config = {})
      defaults
      @filter_config = filter_config
    end

    private

    # Set any default configuration values.
    def defaults
      @filter_config = {}
    end
  end
end
