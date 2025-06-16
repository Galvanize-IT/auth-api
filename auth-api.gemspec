$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auth-api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auth-api"
  s.version     = AuthApi::VERSION
  s.authors     = ["jejacks0n", "dlinch"]
  s.email       = ["software@galvanize.com"]
  s.homepage    = "https://github.com/Galvanize-IT/auth-api"
  s.summary     = "Auth-API: Auth interface"
  s.description = "Interface with Auth including webhooks, API and authentication."
  s.license     = "MIT"

  s.files       = Dir["{app,lib}/**/*"] + ["MIT.LICENSE", "README.md"]

  s.add_dependency "railties", ["7.0.8"]
  s.add_dependency "omniauth-oauth2", ["< 1.7.3"]
  s.add_dependency "mutex_m", ["0.2.0"]
end
