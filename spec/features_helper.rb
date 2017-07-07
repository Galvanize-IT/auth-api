require 'spec_helper'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.javascript_driver = :selenium
Capybara.default_max_wait_time = 10
Capybara.server_host = 'localhost'
Capybara.server_port = 31337

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.use_transactional_fixtures = false

  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = (Capybara.current_driver == :no_redirects) ? :transaction : :truncation
    DatabaseCleaner.start

    Capybara.page.driver.reset!
    Capybara.reset_sessions!
  end

  config.after(:each, type: :feature) do
    Capybara.page.driver.reset!
    Capybara.reset_sessions!

    DatabaseCleaner.clean
  end

  config.before(:suite) do
    begin
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end

  def stub_auth(attrs = {})
    OmniAuth.config.mock_auth[:galvanize] = OmniAuth::AuthHash.new(
      provider: 'galvanize',
      uid: attrs[:uid] || 'Uabc123',
      info: {
        data: {
          id: '1',
          type: 'users',
          attributes: {
            uid: 'Uabc123',
            first_name: 'Sterling',
            last_name: 'Archer',
            email: 'archer@isis.com',
            unconfirmed_email: 'sterling@isis.com',
            created_at: '2017-06-15T21:34:47.296Z',
            updated_at: '2017-06-15T21:34:47.363Z',
            sign_in_count: 0,
            roles: [],
            data: {
              talent: {key: 'value'}
            },
          }.merge(attrs),
          relationships: {
            products: {
              data: [{id: '44', type: 'products'}]
            }
          }
        },
        included: [
          {
            id: '44',
            type: 'products',
            attributes: {
              uid: 'Pabc123',
              name: 'Web Development',
              slug: 'web-development',
              title: 'Galvanize Web Development Foundations with JavaScript - Seattle (7.10)',
              product_type: 'Workshop',
              label: '17-01-WD-GT',
              gcode: 'g666WD',
              campus_name: 'Seattle-Pioneer Square',
              slack_channel: 'g666wd-seattle',
              starts_on: '2017-04-20T11:28:43.000Z',
              ends_on: '2017-04-20T11:28:43.000Z'
            }
          }
        ]
      }
    )
  end

  def unstub_auth
    OmniAuth.config.mock_auth.delete(:galvanize)
  end
end
