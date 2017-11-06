module AuthApi
  class SessionsController < AuthApi.configuration.inherited_controller
    def new
      # Redirect back to root if signed in, otherwise kick off the defined omniauth strategy.
      redirect_to current_user ? after_sign_in(&AuthApi.configuration.after_sign_in_path) : auth_sign_in_path
    end

    def setup
      # You can modify aspects of the strategy here. e.g.
      # request.env['omniauth.strategy'].options['authorize_params'] = {user_type: 'foo'} if session[:signup]
      head 200
    end

    def create
      # Find and/or optionally create your user.
      auth = request.env["omniauth.auth"]
      unless auth
        raise AuthApi::UserResolutionError, "There was an error processing your request type"
      end

      resource = Resource::Base.resolve_resources(auth.info) if auth.info.data
      user = AuthApi.configuration.user_resolver.call(resource) unless resource.nil?
      unless user&.persisted?
        raise AuthApi::UserResolutionError, "We were unable to find or create a user based on your credentials"
      end

      # Reset the session and assign the users uid to the clean session.
      reset_session
      session[:user_uid] = user.uid
    rescue AuthApi::UserResolutionError => e
      # Set the flash message.
      flash[:alert] = e.message
    ensure
      # Redirect to where you think they should go.
      redirect_to after_sign_in(&AuthApi.configuration.after_sign_in_path)
    end

    def failure
      # Notes:
      # 1. Exceptions are raised in dev -- set `config.consider_all_requests_local = false` if you want to get here.
      # 2. There are some details in params you can use if desired.
      # 3. Put `rescue_from AuthApi::AuthFailure, with: :handle_auth_failure` (and define handle_auth_failure) in your
      #    application controller if you want to handle this.
      raise AuthApi::AuthFailure, params.to_json
    end

    def destroy
      # Sign out from our session.
      session[:user_uid] = nil

      # Sign out from everywhere.
      redirect_to auth_sign_out_path
    end

    private

    def after_sign_in(&block)
      main_app.instance_exec(&block)
    end

    def auth_sign_in_path
      [AuthApi.configuration.mounted_at, "auth", AuthApi.configuration.strategy_name].join("/")
    end

    def auth_sign_out_path
      [AuthApi.configuration.url, "/sign_out?redirect=", main_app.root_url].join("")
    end
  end
end
