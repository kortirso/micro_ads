# frozen_string_literal: true

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

    desc 'Creates ad'
    params do
      build_with Grape::Extensions::Hash::ParamBuilder
      requires :ad, type: Hash do
        requires :title,       type: String, desc: 'Title'
        requires :city,        type: String, desc: 'City'
        optional :description, type: String, desc: 'Description'
        optional :lat,         type: Float,  desc: 'Latitude'
        optional :lon,         type: Float,  desc: 'Longitude'
      end
      requires :user_id, type: String, desc: 'User ID'
    end
    post 'ads' do
      service = Ads::CreateService.call(params)

      if service.success?
        { ad: AdSerializer.new(service.result).serializable_hash }
      else
        ErrorSerializer.from_messages(service.errors)
      end
    end
  end
end
