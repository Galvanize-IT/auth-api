module AuthApi
  class Error < StandardError; end
  class NoBlockGiven < AuthApi::Error; end
end
