# frozen_string_literal: true

require 'yaml'
require 'sequel'
require 'sequel/adapters/postgres'

if File.exist?("#{Dir.pwd}/config/database.yml")
  config = YAML.load_file("#{Dir.pwd}/config/database.yml")

  Sequel.postgres(config['database'], user: config['user'], password: config['password'], host: config['host'], port: config['port'])
end
