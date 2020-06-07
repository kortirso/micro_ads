# frozen_string_literal: true

namespace :db do
  desc 'Run database migrations'
  task :migrate, %i[version] => [:settings] do |_t, args|
    require 'sequel/core'
    Sequel.extension :migration

    Sequel.connect(Settings.db.to_hash) do |db|
      migrations = File.expand_path('../../db/migrations', __dir__)
      version = args.version.to_i if args.version
      Sequel::Migrator.run(db, migrations, target: version)
      puts '*** db:migrate executed ***'

      Rake::Task['db:schema:dump'].invoke
    end
  end
end
