# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

Dir[File.expand_path('../../api/*.rb', __FILE__)].each do |f|
  require f
end

# database config
require_relative '../app/setup'
# database models
require_relative '../app/models'
# serializers
require_relative '../app/serializers'

# api endpoints
require_relative '../app/app'
