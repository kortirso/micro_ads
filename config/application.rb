# frozen_string_literal: true

class Application < Grape::API
  mount ::Api::V1

  def self.root
    File.expand_path('..', __dir__)
  end

  def self.environment
    ENV['RACK_ENV'].to_sym
  end

  logger Ougai::Logger.new(
    root.concat('/', Settings.logger.path),
    level: Settings.logger.level
  )

  logger.before_log = lambda do |data|
    data[:service] = { name: Settings.app.name }
    data[:request_id] ||= Thread.current[:request_id]
  end

  helpers do
    def logger
      API.logger
    end
  end
end
