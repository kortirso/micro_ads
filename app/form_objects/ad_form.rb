# frozen_string_literal: true

class AdForm < Dry::Struct
  module Types
    include Dry::Types(default: :nominal)
  end

  attribute :id, Types::Integer.optional
  attribute :title, Types::String
  attribute :city, Types::String
  attribute :description, Types::String.optional
  attribute :lat, Types::String.optional
  attribute :lon, Types::String.optional
  attribute :user_id, Types::Integer

  attr_reader :ad, :errors

  def save
    attributes = to_hash
    attributes[:id] ? update(attributes) : create(attributes)
  end

  private

  def create(attributes)
    schema = AdCreateContract.new.call(attributes)
    return false unless schema_is_valid?(schema)

    @ad = Ad.new
    ad.set(attributes.except(:id))
    ad.save
  end

  def update(attributes)
    schema = AdUpdateContract.new.call(attributes)
    return false unless schema_is_valid?(schema)

    @ad = Ad.first(id: attributes[:id])
    ad.update(attributes.except(:id, :user_id))
  end

  def schema_is_valid?(schema)
    @errors = schema.errors(locale: I18n.locale).to_h.values.flatten
    return true if errors.empty?

    false
  end
end

class AdCreateContract < Dry::Validation::Contract
  config.messages.namespace = :ad
  config.messages.load_paths << 'config/locales/en.yml'
  config.messages.load_paths << 'config/locales/ru.yml'

  schema do
    required(:title).filled(:string)
    required(:city).filled(:string)
    required(:user_id).filled(:integer)
  end
end

class AdUpdateContract < Dry::Validation::Contract
  config.messages.namespace = :ad
  config.messages.load_paths << 'config/locales/en.yml'
  config.messages.load_paths << 'config/locales/ru.yml'

  schema do
    required(:id)
  end
end
