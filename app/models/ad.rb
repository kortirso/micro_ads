# frozen_string_literal: true

class Ad < Sequel::Model
  def self.empty_params
    {
      title:       nil,
      description: nil,
      city:        nil,
      lat:         nil,
      lon:         nil,
      user_id:     nil
    }
  end
end
