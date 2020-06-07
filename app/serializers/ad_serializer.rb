# frozen_string_literal: true

class AdSerializer
  include FastJsonapi::ObjectSerializer

  set_type :ad
  attributes :title, :description, :city, :lat, :lon
end
