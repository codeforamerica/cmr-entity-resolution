# frozen_string_literal: true

module Source
  # Base class for data sources.
  class Base
    # Initialize a new source.
    #
    # @param source_config [Hash] Configuration for this source.
    def initialize(source_config = {})
      @source_config = defaults.merge(source_config)
    end

    # Iterator for records from the source.
    #
    # @yield
    # @yieldparam record [Hash] A single record from the source.
    def each
      raise NotImplementedError, 'Base class does not records to iterate over.'
    end

    private

    # Maps a field from the source to its mapped counterpart.
    #
    # @param field [String] The name of the field to get the mapping for.
    # @return [String] The mapped field name.
    def field_mapper(field)
      @source_config[:field_map][field.to_sym].to_sym
    end

    # Define default configuration values.
    #
    # @return [Hash]
    def defaults
      { field_map: [] }
    end
  end
end