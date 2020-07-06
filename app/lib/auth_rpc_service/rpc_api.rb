# frozen_string_literal: true

require 'securerandom'

module AuthRpcService
  module RpcApi
    def verify_token(token)
      payload = { token: token }.to_json
      publish(payload, type: 'verify_token')
    end
  end
end
