require 'net/http'
require 'auth-api/endpoints/users'
require 'auth-api/endpoints/products'

module AuthApi
  class Client
    API_ENDPOINT = '/api/v1/'

    include AuthApi::Endpoints::Products

    def initialize(scope = '')
      @scope = scope
    end

    def post(path, params = {}, headers = {}, &block)
      request(:post, endpoint(path), headers) do |request|
        request.body = params.to_json
        handle_response_for(request, &block)
      end
    end

    def put(path, params = {}, headers = {}, &block)
      request(:put, endpoint(path), headers) do |request|
        request.body = params.to_json
        handle_response_for(request, &block)
      end
    end
    alias_method :patch, :put

    def delete(path, params = {}, headers = {}, &block)
      request(:delete, endpoint(path, params), headers) do |request|
        handle_response_for(request, &block)
      end
    end

    def get(path, params = {}, headers = {}, &block)
      request(:get, endpoint(path, params), headers) do |request|
        handle_response_for(request, &block)
      end
    end

    def request(method, uri, headers)
      @http = Net::HTTP.new(uri.host, uri.port)
      @http.use_ssl = true

      yield case method
      when :post then Net::HTTP::Post.new(uri.request_uri, default_headers(headers))
      when :put then Net::HTTP::Put.new(uri.request_uri, default_headers(headers))
      when :delete then Net::HTTP::Delete.new(uri.request_uri, default_headers(headers))
      else Net::HTTP::Get.new(uri.request_uri, default_headers(headers))
      end
    end

    def handle_response_for(request)
      response = @http.request(request)
      raise AuthApi::RequestFailed, response.body if response.code.to_i > 300

      result = Resource::Base.resolve_resources(JSON.parse(%{{"body": #{response.body || '{"data": []}'}}}).deep_symbolize_keys[:body])
      return yield result if block_given?
      result
    end

    private

    def token_info
      @auth_info ||= begin
        response = Net::HTTP.post_form(URI.parse(AuthApi.configuration.url + '/api/oauth/token'), {
          grant_type: 'client_credentials',
          client_id: AuthApi.configuration.client_id,
          client_secret: AuthApi.configuration.client_secret,
          scope: @scope,
        })

        raise AuthApi::UnableToAuthenticate, response.body if response.code != '200'
        JSON.parse(response.body).deep_symbolize_keys
      end
    end

    def default_headers(headers)
      {'Content-Type' => 'application/json', 'Authorization' => "Bearer #{token_info[:access_token]}"}.merge(headers)
    end

    def endpoint(path, params = {})
      uri = URI.parse(AuthApi.configuration.url + API_ENDPOINT + path.gsub(/^\//, ''))
      uri.query = URI.encode_www_form(params) unless params.empty?
      uri
    end
  end
end
