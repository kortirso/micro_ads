# frozen_string_literal: true

module Ads
  class UpdateService
    prepend BasicService

    option :id
    option :lat
    option :lon

    option :ad, default: proc { Ad.first(id: @id) }

    def call
      return fail!('Ad is not found') unless @ad

      @ad.update(lat: @lat, lon: @lon)
    end
  end
end
