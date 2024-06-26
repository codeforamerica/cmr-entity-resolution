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

    # Returns the configuration for the current source.
    #
    # @return [Hash]
    def config
      @source_config
    end

    # Iterator for records from the source.
    #
    # @yield
    # @yieldparam record [Hash] A single record from the source.
    def each
      raise NotImplementedError, 'Base class nas no records to iterate over.'
    end

    # Name of the current source.
    #
    # Defaults to the class name (without namespace) if no name has been
    # specified in the configuration for the source.
    #
    # @return [String]
    def name
      @source_config[:name] || default_name
    end

    private

    # Maps a field from the source to its mapped counterpart.
    #
    # If there is no map for the specified field, the field name will be
    # returned as a symbol.
    #
    # @param field [String] The name of the field to get the mapping for.
    # @return [Symbol] The mapped field name.
    def field_mapper(field)
      @source_config[:field_map][field.to_sym]&.to_sym || field.to_sym
    end

    # Define default configuration values.
    #
    # @return [Hash]
    def defaults
      { field_map: {} }
    end

    # Default name for the current source.
    #
    # @return [String]
    def default_name
      self.class.name.split('::').last
    end
  end
end
