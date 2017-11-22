module AuthApi
  class User < Resource::Base
    define_array_attributes :products, :registrations, :roles
    def full_name
      [first_name, last_name].compact.join(' ')
    end
  end
end
