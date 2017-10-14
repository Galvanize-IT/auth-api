module AuthApi
  class WebhookConstraint
    def self.matches?(request)
      token_match = request.headers["X-Auth-Token"] == AuthApi.configuration.webhook_token
      request.env[:resolved_resource] = Resource::Base.resolve_resources(request.params)
      token_match
    end
  end
end
