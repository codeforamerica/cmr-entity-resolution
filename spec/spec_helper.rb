# frozen_string_literal: true

require 'factory_bot'

# Configure code coverage reporting.
if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.minimum_coverage 95
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
