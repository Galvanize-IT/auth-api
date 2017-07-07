Auth API
========

This gem has the basics required to get started using Auth. 

You can build all of the things you may need manually, but this gem includes several aspects that you would otherwise need to build. You can feel free to use the gem or use it as an example.

## Installation

```ruby
gem 'auth-api', github: 'Galvanize-IT/auth-api'
```

To get the basic configuration initializer, run the install generator.

```shell
rails generate auth_api:install
```

## Usage

### Sign In / Out (a.k.a Sessions)

To get the basic authentication logic, you simply need to mount the engine (this happens when you run the install generator).

The configuration comes with some default user find/resolve functionality that's used in the process of signing a user in, but you'll probably want to change or enhance it based on your needs.

To force sign in, just redirect or link the user to `auth_api_engine.new_session_path` if no `current_user` is found. The controller can be easily overridden as well should you need your own functionality.

To sign out provide a link to `auth_api_engine.destroy_session_path`.

### Webhook Constraint

To make sure the requests are in fact coming from Auth, a pre-controller action check needs to be done. This should check that the token provided from Auth matches the one configured in the initializer.

The gem ships with a routing constraint that will do this check for you. Simply put your webhook routes within the constraint check. 

```ruby
constraints AuthApi::WebhookConstraint do
  match '/auth/webhook', via: :post
end
```

