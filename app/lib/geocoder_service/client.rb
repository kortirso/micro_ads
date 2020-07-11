# frozen_string_literal: true

require 'dry/initializer'
require_relative 'geocode'

module GeocoderService
  class Client
    extend Dry::Initializer[undefined: false]
    include Geocode

    option :url, default: proc { Settings.service.geocoder.url }
    option :connection, default: proc { build_connection }

    private

    def build_connection
      Faraday.new(@url) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
