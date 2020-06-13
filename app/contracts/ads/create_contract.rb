# frozen_string_literal: true

module Ads
  class CreateContract < Dry::Validation::Contract
    params do
      required(:title).filled(:string)
      required(:city).filled(:string)
      optional(:description)
      optional(:lat)
      optional(:lon)
    end
  end
end
