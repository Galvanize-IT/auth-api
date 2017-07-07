module AuthApi
  class Engine < ::Rails::Engine
    isolate_namespace AuthApi

    initializer 'auth_api.middleware' do |app|
      config = AuthApi.configuration
      app.config.middleware.use OmniAuth::Builder do
        provider :galvanize, config.client_id, config.client_secret, {setup: true, client_options: {site: config.url}}
      end
    end

    initializer 'auth_api.action_controller' do
      ActiveSupport.on_load(:action_controller) { include AuthApi::ControllerAdditions }
    end
  end
end
