module AuthApi
  class WebhookConstraint
    def self.matches?(request)
      request.headers['X-Auth-Token'] == AuthApi.configuration.webhook_token
    end
  end
end
