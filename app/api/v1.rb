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

    # rubocop: disable Metrics/BlockLength
    resource :ads do
      desc 'Returns the list of ads'
      get do
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
      post do
        user_id = Auth::CallService.call(token: params.fetch(:token)).result
        return error!(ErrorSerializer.from_messages('Forbidden'), 403) unless user_id

        service = Ads::CreateService.call(
          ad:      params.fetch(:ad),
          user_id: user_id
        )

        if service.success?
          { ad: AdSerializer.new(service.result).serializable_hash }
        else
          error!(ErrorSerializer.from_messages(service.errors), 400)
        end
      end

      desc 'Updates ad'
      params do
        build_with Grape::Extensions::Hash::ParamBuilder
        requires :id,             type: String, desc: 'Ad ID'
        requires :correlation_id, type: String, desc: 'Correlation ID for check'
        requires :ad,             type: Hash do
          optional :lat, type: String, desc: 'Latitude'
          optional :lon, type: String, desc: 'Longitude'
        end
      end
      put ':id' do
        ad = Ad.first(id: params.fetch(:id))
        if ad.nil? || ad.correlation_id != params.fetch(:correlation_id, '')
          return error!(ErrorSerializer.from_messages('Forbidden'), 403)
        end

        service = Ads::UpdateService.call(
          ad:     ad,
          params: params.fetch(:ad)
        )

        if service.success?
          { ad: AdSerializer.new(ad.reload).serializable_hash }
        else
          error!(ErrorSerializer.from_messages(service.errors), 400)
        end
      end
    end
    # rubocop: enable Metrics/BlockLength
  end
end
