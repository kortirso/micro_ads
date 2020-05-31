# frozen_string_literal: true

require 'fast_jsonapi'

class AdSerializer
  include FastJsonapi::ObjectSerializer

  set_type :ad
  attributes :title, :description, :city, :lat, :lon, :created_at, :updated_at
end
