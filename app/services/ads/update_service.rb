# frozen_string_literal: true

module Ads
  class UpdateService
    prepend BasicService

    option :ad
    option :params

    def call
      @ad.update(@params.merge(correlation_id: nil))
    end
  end
end
