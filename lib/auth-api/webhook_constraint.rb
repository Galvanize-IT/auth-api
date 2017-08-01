module AuthApi
  class WebhookConstraint
    def self.matches?(request)
      token_match = request.headers['X-Auth-Token'] == AuthApi.configuration.webhook_token
      # fun things, like changing request.env, or adding info to it.
      request.env[:resolved_resource] = Resource::Base.resolve_resources(request.params)
      return token_match
    end
  end
end
