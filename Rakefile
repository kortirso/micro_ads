# frozen_string_literal: true

require 'bundler'
require 'yaml'
require 'json'
require 'sequel'
require 'sequel/extensions/migration'
require 'sequel/adapters/postgres'

Bundler.require(:deploy)
$:.unshift './db'

namespace :db do
  config = YAML.load_file("#{Dir.pwd}/config/database.yml")

  task :connect do
    DB = Sequel.postgres(config['database'], user: config['user'], password: config['password'], host: config['host'], port: config['port'])
  end

  desc 'Perform migration reset (full erase and migration up).'
  task :reset => [:connect] do
    Sequel::Migrator.run(DB, "#{Dir.pwd}/db/migrations", :target => 0)
    Sequel::Migrator.run(DB, "#{Dir.pwd}/db/migrations")
    puts '*** db:reset executed ***'
  end

  desc 'Perform migration up to latest migration available.'
  task :migrate => [:connect] do
    Sequel::Migrator.run(DB, "#{Dir.pwd}/db/migrations")
    puts '*** db:migrate executed ***'
  end

  desc 'Load data to database.'
  task :seed => [:connect] do
    ads = DB.from(:ads)
    JSON.parse(File.read("#{Dir.pwd}/db/seeds.json")).each do |seed|
      current_date = DateTime.now
      ads.insert(
        title:       seed.fetch('title'),
        description: seed.fetch('description'),
        city:        seed.fetch('city'),
        lat:         seed.fetch('lat').to_f,
        lon:         seed.fetch('lon').to_f,
        user_id:     seed.fetch('user_id').to_i,
        created_at:  current_date,
        updated_at:  current_date
      )
    end

    puts '*** db:seed executed ***'
  end
end
