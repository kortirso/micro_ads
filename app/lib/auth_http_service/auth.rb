# frozen_string_literal: true

module AuthHttpService
  module Auth
    def auth(token)
      return if token.blank?

      response = connection.get('verify_token') do |request|
        request.params['token'] = CGI.escape(token)
      end
      response.body.fetch('user_id') if response.success?
    end
  end
end
