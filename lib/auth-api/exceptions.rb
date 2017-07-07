module AuthApi
  class Error < StandardError; end
  class NoBlockGiven < AuthApi::Error; end
  class UserResolutionError < AuthApi::Error; end
  class AuthFailure < AuthApi::Error; end
end
