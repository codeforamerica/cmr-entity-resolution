# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# IBM doesn't currently have an ARM database driver, so this dependency can
# cause an issue on ARM platforms such as Apple Silicon.
gem 'ibm_db', '~> 5.5' if RUBY_PLATFORM =~ /^x86_64/

group :development do
  gem 'rake', '~> 13.0'
  gem 'rubocop', '~> 1.65'
  gem 'rubocop-factory_bot', '~> 2.26'
  gem 'rubocop-rake', '~> 0.6'
  gem 'rubocop-rspec', '~> 3.0'
end

group :test do
  gem 'factory_bot', '~> 6.2'
  gem 'rack-test', '~> 2.1'
  gem 'rspec', '~> 3.12'
  gem 'rspec-github', '~> 2.4'
  gem 'simplecov', '~> 0.22'
end
