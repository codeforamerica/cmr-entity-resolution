# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'cmr-entity-resolution'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'CMR Entity Resolution'
  s.description = 'An entity resolution solution for automated record clearance.'
  s.authors     = ['Code for America']
  s.email       = 'cmr@codeforamerica.org'
  s.bindir = 'exe'
  s.executables = %w[postprocess preprocess]
  s.files       = Dir['lib/**/*'] +
                  Dir['config/*'] +
                  Dir['exe/*'] +
                  Dir['Gemfile*'] +
                  ['Rakefile']
  s.homepage    = 'https://codeforamerica.org/programs/criminal-justice/automatic-record-clearance/'
  s.metadata    = {
    'bug_tracker_uri' => 'https://github.com/codeforamerica/cmr-entity-resolution/issues',
    'homepage_uri' => s.homepage,
    # Require privileged gem operations (such as publishing) to use MFA.
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/codeforamerica/cmr-entity-resolution'
  }

  s.required_ruby_version = '>= 3.2'

  # Add runtime dependencies.
  s.add_runtime_dependency 'thor', '~> 1.2'
  s.add_runtime_dependency 'yajl-ruby', '~> 1.4'

  # Add development dependencies.
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rubocop', '~> 1.48'
  s.add_development_dependency 'rubocop-rake', '~> 0.6'
end
