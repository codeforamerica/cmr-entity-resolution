# frozen_string_literal: true

require 'factory_bot'

# Configure code coverage reporting.
if ENV['COVERAGE']
  require 'simplecov'

  # TODO: Enable with a reasonable setting.
  # SimpleCov.minimum_coverage 50
  SimpleCov.start do
    add_filter '/spec/'

    track_files 'lib/**/*.rb'
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

# Include shared examples and factories.
require_relative 'support/examples'
require_relative 'support/factories'
