# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'cmr-entity-resolution'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'CMR Entity Resolution'
  s.description = 'An entity resolution solution for automated record clearance.'
  s.authors     = ['Code for America']
  s.email       = 'cmr@codeforamerica.org'
  s.bindir      = 'exe'
  s.executables = %w[exporter importer]
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
  s.add_dependency 'csv', '~> 3.3'
  s.add_dependency 'faraday', '~> 2.7'
  s.add_dependency 'faraday-retry', '~> 2.3'
  s.add_dependency 'grape', '~> 2.0'
  s.add_dependency 'ibm_db', '~> 5.5'
  s.add_dependency 'iteraptor', '~> 0.10'
  s.add_dependency 'mongo', '~> 2.18'
  s.add_dependency 'mysql2', '~> 0.5'
  s.add_dependency 'rack', '~> 3.0'
  s.add_dependency 'rackup', '~> 2.1'
  s.add_dependency 'sequel', '~> 5.68'
  s.add_dependency 'thor', '~> 1.2'
  s.add_dependency 'yajl-ruby', '~> 1.4'
end
