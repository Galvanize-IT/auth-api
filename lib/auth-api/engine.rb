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

    routes do
      match 'sign_in', to: 'sessions#new', via: :get, as: :new_session
      match 'sign_out', to: 'sessions#destroy', via: :get, as: :destroy_session
      scope '/auth', via: [:get, :post] do
        match '/:provider/setup', to: 'sessions#setup'
        match '/:provider/callback', to: 'sessions#create'
        match '/failure', to: 'sessions#failure'
      end
    end
  end
end