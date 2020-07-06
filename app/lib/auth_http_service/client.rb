# frozen_string_literal: true

require 'dry/initializer'
require_relative 'auth'

module AuthHttpService
  class Client
    extend Dry::Initializer[undefined: false]
    include Auth

    option :url, default: proc { 'http://localhost:9292/api/v1' }
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
