# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.7.1'

# framework
gem 'grape', '~> 1.3.3'

# rack
gem 'rack', '~> 2.1.3'

# rake
gem 'rake', '~> 13.0.1'

# web server
gem 'puma', '~> 4.3.5'

# database connection
gem 'pg', '~> 1.2.3'
gem 'sequel', '~> 5.32.0'

# serialization
gem 'fast_jsonapi', '~> 1.5'

# I18n
gem 'i18n', '~> 1.8.2'

# Config
gem 'config', '~> 2.2.1'

# Form objects
gem 'dry-validation', '~> 1.5.0'

# activerecord tasks for schema dump
gem 'activerecord'

# http client
gem 'faraday', '~> 1.0.1'
gem 'faraday_middleware', '~> 1.0.0'

# rabbitmq
gem 'bunny', '>= 2.14.4'

group :development do
  gem 'rubocop', '~> 0.85.0', require: false
  gem 'rubocop-performance', require: false
end

group :test do
  gem 'database_cleaner-sequel', '~> 1.8.0'
  gem 'factory_bot', '~> 5.2.0'
  gem 'json_spec'
  gem 'rack-test', '~> 1.1.0'
  gem 'rspec', '~> 3.9.0'
end
