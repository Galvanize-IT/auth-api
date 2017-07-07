ENV['RAILS_ENV'] ||= 'test'
ENV['RAILS_ROOT'] = File.expand_path('../dummy', __FILE__)
require File.expand_path('../dummy/config/environment', __FILE__)

require 'vcr'
require 'webmock/rspec'
require 'rspec/rails'
require 'capybara/rails'

OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.include RSpec::Rails::ViewRendering
  config.order = 'random'
  config.color = true
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!
  config.default_cassette_options = { match_requests_on: [ :uri, :method ], allow_playback_repeats: true }
  config.filter_sensitive_data('<AUTH_CLIENT_ID>') { AuthApi.configuration.client_id }
  config.filter_sensitive_data('<AUTH_CLIENT_SECRET>') { AuthApi.configuration.client_secret }
  config.filter_sensitive_data('<AUTH_WEBHOOK_TOKEN>') { AuthApi.configuration.webhook_token }
end
