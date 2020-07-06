# frozen_string_literal: true

module Auth
  class CallService
    prepend BasicService

    option :token

    attr_reader :result

    def call
      @result = auth_service.verify_token(@token)
    end

    private

    def auth_service
      AuthRpcService::RpcClient.fetch
    end
  end
end
