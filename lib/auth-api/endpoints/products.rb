module AuthApi
  module Endpoints
    module Products
      def product_details(opts = {})
        raise AuthApi::InvalidOptions, "Must provide `uid` or `id` in options" unless opts[:uid] || opts[:id]
        get "products/#{opts[:uid] || opts[:id]}"
      end

      def create_product(opts = {})
        post "products", product: opts[:product] || opts
      end
    end
  end
end
