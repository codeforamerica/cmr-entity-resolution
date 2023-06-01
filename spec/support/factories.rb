# frozen_string_literal: true

# Allow rspec mocks to be used by factories.
FactoryBot::SyntaxRunner.class_eval do
  include RSpec::Mocks::ExampleMethods
end

require_relative 'factories/config_factory'
require_relative 'factories/senzing_factory'
require_relative 'factories/source/csv_factory'
