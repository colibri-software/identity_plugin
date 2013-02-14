$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "identity-engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "identity-engine"
  s.version     = IdentityEngine::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of IdentityEngine."
  s.description = "TODO: Description of IdentityEngine."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.11"
  s.add_dependency 'bcrypt-ruby'
  s.add_dependency 'bson_ext'
  s.add_dependency 'flash-dance'
  s.add_dependency 'mongoid'
  s.add_dependency 'omniauth-identity'
  
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
end
