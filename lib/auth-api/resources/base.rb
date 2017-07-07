module AuthApi
  autoload :User, 'auth-api/resources/user'
  autoload :Product, 'auth-api/resources/product'

  module Resource
    class Base
      attr_reader :attributes

      def self.resolve_resources(json)
        data = json[:data]
        included = resolve_included_resources(json[:included])

        if data.is_a?(Array)
          data.map { |d| resolve_resource_and_relationships(d, included) }
        else
          resolve_resource_and_relationships(data, included)
        end
      end

      def self.resolve_resource_type(data)
        case data[:type]
        when 'products' then Product.new(data)
        when 'users' then User.new(data)
        end
      end

      def self.resolve_resource_and_relationships(data, included)
        (data[:relationships] || {}).each do |k, v|
          data[:attributes][k.to_sym] = v[:data].map { |r| included[r[:type]][r[:id]] }
        end
        resolve_resource_type(data)
      end

      def self.resolve_included_resources(included)
        return [] if included.blank?
        resolved = {}
        included.each do |record|
          resolved[record[:type]] ||= {}
          resolved[record[:type]][record[:id]] = resolve_resource_type(record)
        end
        resolved
      end

      def initialize(data = {})
        @id = data[:id]
        @attributes = data[:attributes] || {}
      end

      def method_missing(key, *args)
        if key =~ /=$/
          @attributes[key.to_s.gsub(/=$/, '').to_sym] = args[0]
        else
          @attributes[key.to_sym]
        end
      end
    end
  end
end