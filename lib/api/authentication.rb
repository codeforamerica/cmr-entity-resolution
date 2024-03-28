# frozen_string_literal: true

module API
  # Authentication helpers for the API.
  module Authentication
    def authenticate!
      error!('401 Unauthorized', 401) unless headers['authorization'] == auth_key
    end

    def auth_key
      ENV.fetch('CMR_API_KEY', 'ThisIsTheDefaultKey!')
    end
  end
end
