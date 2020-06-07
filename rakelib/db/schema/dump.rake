# frozen_string_literal: true

require 'active_record'

namespace :db do
  namespace :schema do
    desc 'Dump database schema'
    task dump: [:settings] do |_t, _args|
      settings = Settings.db.to_hash
      url = "postgres://#{settings.fetch(:host)}/#{settings.fetch(:database)}"
      ActiveRecord::Base.establish_connection(url)

      File.open('db/schema.rb', 'w:utf-8') do |file|
        ::ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
      puts '*** db:schema:dump executed ***'
    end
  end
end
