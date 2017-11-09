module AuthApi
  autoload :User, "auth-api/resources/user"
  autoload :Product, "auth-api/resources/product"
  autoload :Registration, "auth-api/resources/registration"
  autoload :Identity, "auth-api/resources/identity"

  module Resource
    class Base
      attr_reader :attributes

      def self.resolve_resources(json)
        json = json.deep_symbolize_keys
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
        when "users" then User.new(data)
        when "products" then Product.new(data)
        when "registrations" then Registration.new(data)
        when "identities" then Identity.new(data)
        end
      end

      def self.resolve_resource_and_relationships(data, included)
        return if data.nil?
        (data[:relationships] || {}).each do |k, v|
          data[:attributes][k.to_sym] = resolve_relationships(v[:data], included)
        end
        resolve_resource_type(data)
      end

      def self.resolve_relationships(rels, included)
        return [] if rels.blank?
        if rels.is_a?(Array)
          rels.map do |r|
            included_resources = included[r[:type]]
            next unless included_resources
            resolve_resource_and_relationships(included_resources[r[:id]], included)
          end
        else
          resolve_resource_and_relationships(included[rels[:type]][rels[:id]], included)
        end
      end

      def self.resolve_included_resources(included)
        return [] if included.blank?
        resolved = {}
        included.each do |record|
          resolved[record[:type]] ||= {}
          resolved[record[:type]][record[:id]] = record
        end
        resolved
      end

      def self.define_array_attributes(*attrs)
        attrs.each { |attr| define_method(attr) { @attributes[attr] ||= [] } }
      end

      def initialize(data = {})
        @id = data[:id]
        @attributes = (data[:attributes] || {}).deep_symbolize_keys
      end

      def attribute_intersection(target, target_to_source = {})
        if target.is_a?(Array)
          target_keys = target.map(&:to_sym)
        elsif target.respond_to?(:attributes)
          target_keys = target.attributes.keys.map(&:to_sym)
        elsif target.respond_to?(:keys)
          target_keys = target.keys.map(&:to_sym)
        else
          return {}
        end

        source = attributes.dup

        intersecting_keys = target_keys & source.keys
        intersection = Hash[intersecting_keys.zip(source.values_at(*intersecting_keys))]

        (target_keys - intersecting_keys).each do |key|
          method = target_to_source[key] || key
          if respond_to?(method)
            intersection[key] = send(method)
            target_to_source.delete(key)
          end
        end

        target_to_source.each do |target_key, source_key|
          intersection[target_key] = source[source_key]
        end

        intersection
      end

      def method_missing(key, *args)
        if key =~ /=$/
          key = key.to_s.gsub(/=$/, "").to_sym
          attributes[key] = args[0]
        elsif key =~ /\?$/
          key = key.to_s.gsub(/\?$/, "").to_sym
          !(attributes[key].nil? || attributes[key] == false)
        elsif attributes.key?(key.to_sym)
          attributes[key.to_sym]
        else
          super
        end
      end
    end
  end
end
