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

    attr_reader :result

    def call
      validate_with(Ads::CreateContract, @ad.to_h)
      @result = ::Ad.create(ad_attributes) if errors.blank?
    end

    private

    def ad_attributes
      @ad.to_h.merge(
        'user_id' => @user_id
      ).compact
    end
  end
end
