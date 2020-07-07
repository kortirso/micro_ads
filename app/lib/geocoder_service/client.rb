# frozen_string_literal: true

require 'dry/initializer'
require_relative 'geocode'

module GeocoderService
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
        opts.merge(
          app_id:         'ads',
          persistent:     true,
          correlation_id: opts[:correlation_id]
        )
      )
    end
  end
end
