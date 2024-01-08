module AuthApi
  class Engine < ::Rails::Engine
    isolate_namespace AuthApi

    initializer "auth_api.middleware" do |app|
      config = AuthApi.configuration
      app.config.middleware.use OmniAuth::Builder do
        provider :galvanize, app.secrets.auth_client_id, app.secrets.auth_client_secret,
          setup: true,
          path_prefix: "#{config.mounted_at}/auth",
          client_options: { site: app.secrets.auth_url }
      end
    end

    config.after_initialize do |app|
      mount_at = AuthApi.configuration.mounted_at
      app.routes.prepend { mount AuthApi::Engine, at: mount_at } if mount_at
    end

    initializer "auth_api.action_controller" do
      ActiveSupport.on_load(:action_controller) { include AuthApi::ControllerAdditions }
    end

    routes do
      match "sign_in", to: "sessions#new", via: :get, as: :new_session
      match "sign_out", to: "sessions#destroy", via: :get, as: :destroy_session
      scope "/auth", via: %i[get post] do
        match "/:provider/setup", to: "sessions#setup"
        match "/:provider/callback", to: "sessions#create"
        match "/failure", to: "sessions#failure"
      end
    end
  end
end
