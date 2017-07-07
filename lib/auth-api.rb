require 'omniauth-oauth2'
require 'auth-api/version'
require 'auth-api/exceptions'
require 'auth-api/configuration'
require 'auth-api/controller_additions'
require 'auth-api/galvanize_strategy'
require 'auth-api/webhook_constraint'
require 'auth-api/engine' if defined?(Rails)
