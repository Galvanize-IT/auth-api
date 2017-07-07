module AuthApi
  class Error < StandardError; end
  class NoBlockGiven < AuthApi::Error; end
  class UserResolutionError < AuthApi::Error; end
  class AuthFailure < AuthApi::Error; end
  class RequestFailed < AuthApi::Error; end
  class UnableToAuthenticate < AuthApi::Error; end
  class InvalidOptions < AuthApi::Error; end
end
