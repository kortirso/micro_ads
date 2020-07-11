# frozen_string_literal: true

Sequel::Model.db.loggers.push(Application.logger)
