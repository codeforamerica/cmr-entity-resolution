require_relative 'lib/api'

use Rack::RewindableInput::Middleware

run API
