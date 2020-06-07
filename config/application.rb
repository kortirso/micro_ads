# frozen_string_literal: true

class Application < Grape::API
  mount ::Api::V1

  def self.root
    File.expand_path('..', __dir__)
  end

  def self.environment
    ENV['RACK_ENV'].to_sym
  end
end
