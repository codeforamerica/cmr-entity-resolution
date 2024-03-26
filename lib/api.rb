# frozen_string_literal: true

require 'grape'

require_relative 'config'
require_relative 'import'

# Provides a proxy api for entity resolution.
class API < Grape::API
  format :json

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
      # TODO: Load and modify the config once at startup.
      config = Config.from_file(ENV.fetch('CMR_CONFIG_FILE', 'config/config.yml'))

      # TODO: Return a 404 if the source is not found.
      source = config.sources[params[:source]]
      if source.nil?
        status 404
        return "Source \"#{params[:source]}\" not found."
      end

      # Override configured sources as we only want to use this one.
      source[:type] = 'API::JSON'
      source[:payload] = params
      config.sources = { params[:source] => source }

      # TODO: Pass the source name here as an optional argument.
      Import.new(config).import

      # TODO: Return something better. Make it JSONy.
      'Record imported.'
    end
  end
end
