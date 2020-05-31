# frozen_string_literal: true

require 'v1'

module MicroAds
  class App < Grape::API
    mount ::MicroAds::V1
  end
end
