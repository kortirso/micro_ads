# frozen_string_literal: true

class Application < Grape::API
  mount ::Api::V1

  helpers do
    def logger
      API.logger
    end
  end

  class << self
    def root
      File.expand_path('..', __dir__)
    end

    def environment
      ENV['RACK_ENV'].to_sym
    end
  end
end
