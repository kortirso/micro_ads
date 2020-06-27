# frozen_string_literal: true

module Ads
  class CreateService
    prepend BasicService

    option :ad do
      option :title
      option :description
      option :city
      option :lat, optional: true
      option :lon, optional: true
    end

    option :user_id
    option :geocoder_service, default: proc { GeocoderService::Client.new }

    attr_reader :result

    def call
      validate_with(Ads::CreateContract, @ad.to_h)
      return unless errors.blank?

      @result = ::Ad.create(ad_attributes)
      @geocoder_service.geocode_later(@result)
    end

    private

    def ad_attributes
      @ad.to_h.merge(
        'user_id' => @user_id
      ).compact
    end
  end
end
