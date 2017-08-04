require "singleton"

module AuthApi
  class Configuration
    include Singleton

    cattr_accessor :client_id, :client_secret, :webhook_token, :url, :strategy_name, :inherited_controller, :mounted_at
    @@client_id            = ''
    @@client_secret        = ''
    @@webhook_token        = ''
    @@url                  = ''
    @@strategy_name        = 'galvanize'
    @@inherited_controller = ''
    @@mounted_at           = nil

    cattr_reader :user_finder, :user_resolver
    def self.define_user_finder(&block)
      raise AuthApi::NoBlockGiven unless block_given?
      @@user_finder = block
    end

    def self.define_mount_point(mount)
      @@mounted_at = mount.match(/^\/$/) ? '' : mount
    end

    def self.define_user_resolver(&block)
      raise AuthApi::NoBlockGiven unless block_given?
      @@user_resolver = block
    end
  end

  mattr_accessor :configuration
  @@configuration = Configuration

  def self.configure
    yield @@configuration
  end
end
