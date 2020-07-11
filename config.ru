# frozen_string_literal: true

require_relative 'config/environment'

use Rack::RequestId
use Rack::Ougai::LogRequests, Application.logger

run Application
