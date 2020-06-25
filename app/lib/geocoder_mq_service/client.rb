# frozen_string_literal: true

require 'dry/initializer'
require_relative 'geocode'

module GeocoderMqService
  class Client
    extend Dry::Initializer[undefined: false]
    include Geocode

    option :queue, default: proc { create_queue }

    private

    def create_queue
      channel = RabbitMq.channel
      channel.queue('geocoding', durable: true)
    end

    def publish(payload, opts={})
      @queue.publish(
        payload,
        opts.merge(persistent: true, app_id: 'ads')
      )
    end
  end
end
