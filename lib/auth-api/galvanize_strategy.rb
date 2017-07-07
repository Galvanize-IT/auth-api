module OmniAuth
  module Strategies
    class Galvanize < OmniAuth::Strategies::OAuth2
      option :name, :galvanize

      uid do
        raw_info['data']['attributes']['uid']
      end

      info do
        raw_info
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me').parsed
      end
    end
  end
end
