module AuthApi
  class AuthenticatedConstraint
    def self.matches?(request)
      request.session[:user_uid].present?
    end
  end
end
