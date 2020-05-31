# frozen_string_literal: true

module MicroAds
  class V1 < Grape::API
    prefix 'api'
    version 'v1'
    format :json

    desc 'Returns the current API version'
    get do
      { version: 'v1' }
    end

    desc 'Returns the list of ads'
    get 'ads' do
      { ads: [] }
    end
  end
end
