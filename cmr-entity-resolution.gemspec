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
  s.executables = %w[exporter importer postprocess preprocess]
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
  s.add_runtime_dependency 'faraday', '~> 2.7'
  s.add_runtime_dependency 'ibm_db', '~> 5.4'
  s.add_runtime_dependency 'iteraptor', '~> 0.10'
  s.add_runtime_dependency 'mongo', '~> 2.18'
  s.add_runtime_dependency 'sequel', '~> 5.68'
  s.add_runtime_dependency 'thor', '~> 1.2'
  s.add_runtime_dependency 'yajl-ruby', '~> 1.4'

  # TODO: Remove once ibm_db has been updated to support ruby 3.2.
  s.add_runtime_dependency 'file_exists', '~> 0.2'
end
