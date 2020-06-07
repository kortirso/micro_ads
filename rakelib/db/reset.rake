# frozen_string_literal: true

namespace :db do
  desc 'Reset database'
  task reset: [:settings] do |_t, _args|
    require 'sequel/core'
    Sequel.extension :migration

    Sequel.connect(Settings.db.to_hash) do |db|
      migrations = File.expand_path('../../db/migrations', __dir__)
      Sequel::Migrator.run(db, migrations, target: 0)
      puts '*** db:reset executed ***'
    end
  end
end
