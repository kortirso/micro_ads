# frozen_string_literal: true

module Ads
  class CreateContract < Dry::Validation::Contract
    schema do
      required(:title).filled(:string)
      required(:city).filled(:string)
      required(:user_id).filled(:integer)
    end
  end
end
