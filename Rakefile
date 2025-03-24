# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: %i[spec rubocop]

RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop'
  task.formatters = %w[pacman]
  task.formatters << 'github' if ENV.fetch('GITHUB_ACTIONS', false)
end

RSpec::Core::RakeTask.new(:spec)
