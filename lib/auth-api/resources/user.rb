module AuthApi
  class User < Resource::Base
    define_array_attributes :products, :registrations, :roles
  end
end
