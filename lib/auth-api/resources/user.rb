module AuthApi
  class User < Resource::Base
    def attribute_intersection(keys)
      @attributes.without(*(@attributes.keys - keys))
    end
  end
end
