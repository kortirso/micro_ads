# frozen_string_literal: true

require 'securerandom'

module GeocoderService
  module Geocode
    def geocode_later(ad)
      correlation_id = SecureRandom.uuid
      ad.update(correlation_id: correlation_id)

      payload = { id: ad.id, city: ad.city }.to_json
      publish(payload, type: 'geocode', correlation_id: correlation_id)
    end
  end
end
