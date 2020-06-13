# frozen_string_literal: true

module GeocoderService
  module Geocode
    def geocode(city)
      return if city.blank?

      response = connection.get('geocode') do |request|
        request.params['city'] = CGI.escape(city)
      end
      response.body.fetch('coordinates') if response.success?
    end
  end
end
