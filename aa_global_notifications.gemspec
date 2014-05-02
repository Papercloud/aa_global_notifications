$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "aa_global_notifications/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "aa_global_notifications"
  s.version     = AaGlobalNotifications::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AaGlobalNotifications."
  s.description = "TODO: Description of AaGlobalNotifications."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.0"

  s.add_development_dependency "sqlite3"
end