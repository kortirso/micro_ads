# frozen_string_literal: true

class BasicContract < Dry::Validation::Contract
  config.messages.load_paths << 'config/locales/en.yml'
  config.messages.load_paths << 'config/locales/ru.yml'
end
