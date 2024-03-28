# frozen_string_literal: true

require 'grape'

require_relative 'authentication'
require_relative '../config'
require_relative '../import'

module API
  # Provides a proxy api for entity resolution.
  class API < Grape::API
    format :json

    helpers Authentication

    resource :health do
      get do
        { status: 'ok' }
      end
    end

    resource :import do
      desc 'Import a single record into Senzing.'
      params do
        requires :source, type: Symbol, desc: 'The name of the data source.'
      end
      post do
        authenticate!

        # TODO: Load and modify the config once at startup.
        config = Config.from_file(ENV.fetch('CMR_CONFIG_FILE', 'config/config.yml'))

        # Override configured sources to be of an API type and include the
        # payload.
        config.sources.each_value do |source|
          source[:type] = 'API::JSON'
          source[:payload] = params
        end

        Import.new(config).import_from(params[:source])

        { status: :success }
      rescue Import::SourceNotFound
        status 404
        { status: :error, message: "Source \"#{params[:source]}\" not found." }
      end
    end
  end
end
