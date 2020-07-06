# frozen_string_literal: true

require 'dry/initializer'
require_relative 'rpc_api'

module AuthRpcService
  class RpcClient
    extend Dry::Initializer[undefined: false]
    include RpcApi

    option :queue, default: proc { create_queue }
    option :reply_channel, default: proc { create_reply_channel }
    option :reply_queue, default: proc { create_reply_queue }
    option :lock, default: proc { Mutex.new }
    option :condition, default: proc { ConditionVariable.new }

    def self.fetch
      Thread.current['auth_service.rpc_client'] ||= new.start
    end

    def start
      @reply_queue.subscribe(manual_ack: true) do |_delivery_info, properties, payload|
        if properties[:correlation_id] == @correlation_id
          payload = JSON.parse(payload)
          @result = payload.fetch('user_id')

          publish_default_exchange(properties)
          @lock.synchronize { @condition.signal }
        end
      end

      self
    end

    private

    attr_writer :correlation_id

    def create_queue
      channel = RabbitMq.channel
      channel.queue('auth', durable: true)
    end

    def create_reply_channel
      RabbitMq.consumer_channel
    end

    def create_reply_queue
      @reply_channel.queue('token', durable: true)
    end

    def publish(payload, opts={})
      self.correlation_id = SecureRandom.uuid

      @lock.synchronize do
        @queue.publish(
          payload,
          opts.merge(
            app_id:     'ads',
            reply_to:   @reply_queue.name,
            message_id: @correlation_id
          )
        )

        @condition.wait(@lock)
        @result
      end
    end

    def publish_default_exchange(properties)
      @reply_channel.default_exchange.publish(
        '',
        routing_key:    properties[:reply_to],
        correlation_id: properties[:message_id]
      )
    end
  end
end