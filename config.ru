# frozen_string_literal: true

require_relative 'lib/api/api'

use Rack::RewindableInput::Middleware

run API::API
