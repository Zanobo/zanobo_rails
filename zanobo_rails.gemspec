$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "zanobo_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "zanobo_rails"
  s.version     = ZanoboRails::VERSION
  s.authors     = ["Zanobo Partners"]
  s.email       = ["zach@zanobo.io"]
  s.homepage    = "https://github.com/zrisher/zanobo_rails_common"
  s.summary     = "A gem to help with Rails webapps"
  s.description = "A gem to help with Rails webapps"
  s.license     = "Undecided"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.1.8"
  s.add_dependency 'meta-tags'

  s.add_development_dependency "sqlite3"
end
