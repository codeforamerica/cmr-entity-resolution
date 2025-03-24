# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: %i[spec rubocop]

RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop'
  task.formatters = ENV.fetch('GITHUB_ACTIONS', false) ? %w[github] : %w[pacman]
end

RSpec::Core::RakeTask.new(:spec)
