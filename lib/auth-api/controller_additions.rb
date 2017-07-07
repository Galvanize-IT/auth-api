module AuthApi
  module ControllerAdditions
    extend ActiveSupport::Concern

    included do
      helper_method :current_user
    end

    def current_user
      @current_user ||= AuthApi.configuration.user_finder.call(session[:user_uid])
    end
  end
end

