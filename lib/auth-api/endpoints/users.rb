module AuthApi
  module Endpoints
    module Products
      def user_details(opts = {})
        raise AuthApi::InvalidOptions, 'Must provide `uid` or `id` in options' unless opts[:uid] || opts[:id]
        get "users/#{opts[:uid] || opts[:id]}"
      end
    end
  end
end
