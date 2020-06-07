# frozen_string_literal: true

namespace :db do
  desc 'Seed database'
  task seed: [:settings] do |_t, _args|
    require 'sequel/core'

    Sequel.connect(Settings.db.to_hash) do |db|
      ads = db.from(:ads)

      JSON.parse(File.read("#{Dir.pwd}/db/seeds/ads.json")).each do |seed|
        ads.insert(
          title:       seed.fetch('title'),
          description: seed.fetch('description'),
          city:        seed.fetch('city'),
          lat:         seed.fetch('lat').to_f,
          lon:         seed.fetch('lon').to_f,
          user_id:     seed.fetch('user_id').to_i
        )
      end

      puts '*** db:seed executed ***'
    end
  end
end
