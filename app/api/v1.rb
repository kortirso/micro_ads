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
      requires :title,       type: String, desc: 'Title'
      requires :description, type: String, desc: 'Description'
      requires :city,        type: String, desc: 'City'
      optional :lat,         type: String, desc: 'Latitude'
      optional :lon,         type: String, desc: 'Longitude'
      requires :user_id,     type: String, desc: 'User ID'
    end
    post 'ads' do
      current_date = DateTime.now
      ad_id = Ad.insert(
        title:       params[:title],
        description: params[:description],
        city:        params[:city],
        lat:         params[:lat] ? params[:lat].to_f : nil,
        lon:         params[:lon] ? params[:lon].to_f : nil,
        user_id:     params[:user_id].to_i,
        created_at:  current_date,
        updated_at:  current_date
      )

      { ad: AdSerializer.new(Ad.first(id: ad_id)).serializable_hash }
    end
  end
end
