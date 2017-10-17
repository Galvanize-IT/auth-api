module AuthApi
  class User < Resource::Base
    define_array_attributes :products, :registrations, :roles

    def attribute_intersection(keys)
      if keys.is_a?(Array)
        keys = (keys.map(&:to_sym) & @attributes.keys)
      elsif keys.is_a?(ActiveRecord::Base)
        keys = (keys.attributes.keys.map(&:to_sym) & @attributes.keys)
      else
        keys = (keys.keys.map(&:to_sym) & @attributes.keys)
      end
      Hash[keys.zip(@attributes.values_at(*keys))]
    end
  end
end
