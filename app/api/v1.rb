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
        requires :description, type: String, desc: 'Description'
      end
      requires :token, type: String, desc: 'User token'
    end
    post 'ads' do
      user_id = Auth::CallService.call(token: params.fetch(:token)).result
      return error!(ErrorSerializer.from_messages('Forbidden'), 403) unless user_id

      coordinates = Geocoder::CallService.call(city: params.dig(:ad, :city))
      service = Ads::CreateService.call(
        ad:      params.fetch(:ad).merge(coordinates.result),
        user_id: user_id
      )

      if service.success?
        { ad: AdSerializer.new(service.result).serializable_hash }
      else
        error!(ErrorSerializer.from_messages(service.errors), 400)
      end
    end
  end
end
