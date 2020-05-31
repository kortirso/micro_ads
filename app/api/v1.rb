# frozen_string_literal: true

module MicroAds
  module Api
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
        ads = Ad.reverse_order(:created_at).all

        { ads: AdSerializer.new(ads).serializable_hash }
      end
    end
  end
end
