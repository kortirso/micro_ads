# frozen_string_literal: true

Sequel.connect(Settings.db.to_hash)

Sequel::Model.plugin :timestamps, update_on_create: true

Sequel.default_timezone = :utc
