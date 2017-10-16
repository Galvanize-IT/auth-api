Auth API [![Build](http://circleci-badges-max.herokuapp.com/img/Galvanize-IT/auth-api/master?token=738d6f5d830c1949e753c7243f86fb18f180d6d7)](https://circleci.com/gh/Galvanize-IT/auth-api)
======== 

This gem has the basics required to get started using Auth. 

You can build all of the things you may need manually, but this gem includes several aspects that you would otherwise
need to build. You can feel free to use the gem or use it as an example.


## Installation

```ruby
gem "auth-api", github: "Galvanize-IT/auth-api"
```

To get the basic configuration initializer and routes, run the install generator.

```shell
rails generate auth_api:install
```


## Usage

### Configuration

Before you start integrating with Auth, you'll need to register your application within the Galvanize Auth system. To do
this talk with a developer, or if you already have access to create an application, do so yourself.

Once you have an application registered, you should be able to configure the `client_id`, `client_secret`,
and `webhook_token` in the `auth_api.rb` initializer that was provided in the install generator.

### Sign In / Out

To get the basic authentication logic, you simply need to mount the engine (this happens when you run the install
generator).

The configuration comes with some default user find/resolve functionality that's used in the process of signing a user
in, but you'll probably want to change or enhance it based on your needs.

To force sign in, just redirect or link the user to `auth_api.new_session_path` if no `current_user` is found. The
controller can be easily overridden as well should you need your own functionality.

To sign out provide a link to `auth_api.destroy_session_path`.

### Webhook Constraint

To make sure the requests are in fact coming from Auth, a pre-controller action check needs to be done. This should
check that the token provided from Auth matches the one configured in the initializer.

The gem ships with a routing constraint that will do this check for you. Simply put your webhook routes within the
constraint check.

Then inside your controller, the resource provided in the webhook request can be found at
`request.env[:resolved_resource]`. This resource will have the same behaviors as those provided through the API
interface.  

```ruby
constraints AuthApi::WebhookConstraint do
  match "/auth/webhook", via: :post
end
```

### Authenticated Constraint

This constraint provides a simple and handy way to require a user to be signed in. If no user session was found Rails
will just return a 404, like the nested routes don't exist.

```ruby
constraints AuthApi::UserConstraint do
  match "/restricted_path", via: :get
end
```

### API Interface

```ruby
client = AuthApi::Client.new

product = client.product_details(uid: "abc123")
product.title # => 'Web Development'

users = client.user_search(terms: "jejacks0n")
users.count # => 1 
users.first.first_name # => Jeremy
users.first.products # => [AuthApi::Product]
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
