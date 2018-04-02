module AuthApi
  class Product < Resource::Base
    def cohort_name
      name
    end
  end
end
