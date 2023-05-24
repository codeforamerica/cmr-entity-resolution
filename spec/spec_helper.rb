# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'

  # TODO: Enable with a reasonable setting.
  # SimpleCov.minimum_coverage 50
  SimpleCov.start do
    add_filter '/spec/'

    track_files 'lib/**/*.rb'
  end
end
