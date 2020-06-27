# frozen_string_literal: true

module GeocoderService
  module Geocode
    def geocode_later(ad)
      payload = { id: ad.id, city: ad.city }.to_json
      publish(payload, type: 'geocode')
    end
  end
end
