# frozen_string_literal: true

module Auth
  class CallService
    prepend BasicService

    option :token

    attr_reader :result

    def call
      @result = auth_service.auth(@token)
    end

    private

    def auth_service
      AuthService::Client.new
    end
  end
end
