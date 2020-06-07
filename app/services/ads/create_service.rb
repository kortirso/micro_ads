# frozen_string_literal: true

module Ads
  class CreateService
    prepend BasicService

    option :title
    option :description
    option :city
    option :lat
    option :lon
    option :user_id

    attr_reader :ad

    def call
      ad_form = AdForm.new(
        id:          nil,
        title:       @title,
        city:        @city,
        description: @description,
        lat:         @lat.to_f,
        lon:         @lon.to_f,
        user_id:     @user_id.to_i
      )

      fail!(ad_form.errors) unless ad_form.save
      @ad = ad_form.ad
    end
  end
end
