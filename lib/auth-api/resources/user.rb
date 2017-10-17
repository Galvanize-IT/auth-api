module AuthApi
  class User < Resource::Base
    define_array_attributes :products, :registrations, :roles

    def attribute_intersection(keys)
      @attributes.without(*(@attributes.keys - keys))
    end
  end
end
