# frozen_string_literal: true

channel = RabbitMq.consumer_channel
exchange = channel.default_exchange

queue = channel.queue('ads', durable: true)
queue.subscribe(manual_ack: true) do |_delivery_info, properties, payload|
  payload = JSON.parse(payload)
  lat, lon = payload.fetch('coordinates')
  Ads::UpdateService.call(
    id:  payload.fetch('id'),
    lat: lat,
    lon: lon
  )

  exchange.publish(
    '',
    routing_key:    properties[:reply_to],
    correlation_id: properties[:correlation_id]
  )
end
