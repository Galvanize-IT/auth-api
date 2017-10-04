module AuthApi
  module ControllerAdditions
    extend ActiveSupport::Concern

    included do
      if respond_to?(:helper_method)
        helper_method :current_user
      end
    end

    def current_user
      @current_user ||= AuthApi.configuration.user_finder.call(session[:user_uid]) unless session[:user_uid].nil?
    end
  end
end

