# frozen_string_literal: true

class Application < Grape::API
  mount ::Api::V1

  class << self
    attr_accessor :logger

    def root
      File.expand_path('..', __dir__)
    end

    def environment
      ENV['RACK_ENV'].to_sym
    end
  end

  helpers do
    def logger
      API.logger
    end
  end
end
