# frozen_string_literal: true

module Geocoder
  class CallService
    prepend BasicService

    option :city

    attr_reader :result

    def call
      response = geocoder_service.geocode(@city)
      Application.logger.info(
        'geocoded city',
        city:     @city,
        response: response
      )
      @result = response ? coordinates(response) : {}
    end

    private

    def geocoder_service
      GeocoderService::Client.new
    end

    def coordinates(response)
      {
        lat: response[0],
        lon: response[1]
      }
    end
  end
end
