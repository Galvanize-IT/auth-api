module AuthApi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc 'Installs the AuthApi initializer into your application.'

      def copy_initializer
        template 'auth_api.rb.tt', 'config/initializers/auth_api.rb'
      end

      def mount_engine_routes
        route 'mount AuthApi::Engine, at: \'/\''
      end
    end
  end
end
