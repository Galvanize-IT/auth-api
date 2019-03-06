module AuthApi
  module Endpoints
    module Users
      def user_details(opts = {})
        raise AuthApi::InvalidOptions, "Must provide `uid` or `id` in options" unless opts[:uid] || opts[:id]
        get "users/#{opts[:uid] || opts[:id]}"
      end

      def create_user(opts = {})
        post "users", user: opts[:user] || opts
      end

      def update_user(opts = {})
        patch "users/#{opts[:id]}", user: opts[:user] || opts
      end

      def invite_user(opts = {})
        post "users/invite", user: opts[:user] || opts
      end
    end
  end
end
