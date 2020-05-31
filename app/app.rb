# frozen_string_literal: true

require_relative 'api/v1'

module MicroAds
  class App < Grape::API
    mount ::MicroAds::Api::V1
  end
end
