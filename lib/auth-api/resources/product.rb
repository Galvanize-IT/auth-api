module AuthApi
  class Product < Resource::Base
    def cohort_name
      if gcode.present? && pretty_name.present?
        gcode + " " + pretty_name
      else
        pretty_name
      end
    end
  end
end
