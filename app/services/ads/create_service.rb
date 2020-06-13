# frozen_string_literal: true

module Ads
  class CreateService
    prepend BasicService

    option :title
    option :description
    option :city
    option :lat, optional: true
    option :lon, optional: true
    option :user_id

    attr_reader :ad

    def call
      contract = Ads::CreateContract.new
      errors = contract.call(ad_attributes).errors.to_h
      return fail!(errors) if errors.size.positive?

      @ad = Ad.create(ad_attributes)
    end

    private

    def ad_attributes
      @ad_attributes ||=
        {
          title:       @title,
          city:        @city,
          description: @description,
          lat:         @lat.to_f,
          lon:         @lon.to_f,
          user_id:     @user_id.to_i
        }.compact
    end
  end
end
