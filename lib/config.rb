# frozen_string_literal: true

require 'logger'
require 'psych'

# Manage configuration settings.
class Config
  class << self
    # Creates a new configuration object and applies values from a YAML config.
    #
    # @param path [String] Path the YAML file to load for config.
    # @return [Config]
    def from_file(path)
      options = Psych.load_file(path, symbolize_names: true)
      config = new do |c|
        options.each do |option, value|
          c.send("#{option}=", value)
        end
      end

      config.logger.info("Config loaded from #{path}")

      config
    end
  end

  attr_accessor :destination, :field_map, :filters, :log_level, :logger,
                :match_level, :match_score, :senzing, :sources, :transformations

  def initialize
    defaults
    yield self if block_given?
    initialize_logger
  end

  private

  # Set default configuration values.
  def defaults
    @destination = {}
    @field_map = []
    @filters = []
    @log_level = 'WARN'
    @match_level = 2
    @match_score = 5
    @senzing = {}
    @sources = []
    @transformations = []
  end

  def initialize_logger
    @logger ||= Logger.new($stdout, level: Logger.const_get(@log_level.upcase))
  end
end
