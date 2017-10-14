AuthApi.configure do |config|

  # Different environments can use different Auth urls.
  config.url = "https://auth-staging.galvanize.com"

  # Provide the Client ID, Secret, and Webhook Token as provided through the Auth application interface.
  config.client_id = ""
  config.client_secret = ""
  config.webhook_token = ""

  # The mount point that the engine is to be placed. Allows namespacing of omniauth callback methods. Set to
  #  nil or remove the line to prevent the gem from mounting the engine, this allows you to mount it manually.
  config.define_mount_point "/"

  # The user lookup based on uid. Provide a block that will return the user that's been resolved.
  config.define_user_finder { |uid| User.find_by(uid: uid) }

  # When a session is being created, we can find or create a user. This doesn't need to create a user however,
  # so implement what makes sense -- if no user is returned, an AuthApi::UserResolutionError is raised which
  # can be handled in your application controller.
  config.define_user_resolver do |auth_user|
    # Pull only the attributes we want.
    attrs = auth_user.attribute_intersection(User.new.attributes.keys)

    # Find the user or create a new one (the creating of one is totally optional).
    user = User.find_by(uid: auth_user.uid) || User.new(attrs)

    # We update the last time we saw them, but...
    # 1. You may want to pull in data like what products they've registered for, etc.
    # 2. When you expand on this logic, it should be moved to a service object and out of this config block.
    user.update(last_seen_at: Time.zone.now)

    # Finally, return the user.
    user
  end
end
