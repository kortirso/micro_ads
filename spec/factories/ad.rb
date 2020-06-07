# frozen_string_literal: true

FactoryBot.define do
  factory :ad do
    title { 'Title' }
    description { 'Description' }
    city { 'London' }
    lat { 0.0 }
    lon { 0.0 }
    user_id { 1 }
  end
end
