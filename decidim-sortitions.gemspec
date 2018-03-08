# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/sortitions/version"

Gem::Specification.new do |s|
  s.name = "decidim-sortitions"
  s.summary = "This module makes possible to select amont a set of proposal by sortition"
  s.description = s.summary
  s.version = Decidim::Sortitions::VERSION
  s.authors = ["Juan Salvador Perez Garcia"]
  s.email = ["jsperezg@gmail.com"]
  s.license = "AGPLv3"
  s.homepage = "https://github.com/AjuntamentdeBarcelona/decidim"
  s.required_ruby_version = ">= 2.3.1"

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "Rakefile", "README.md", "LICENSE-AGPLv3.txt"]

  s.add_dependency "decidim-admin"
  s.add_dependency "decidim-comments"
  s.add_dependency "decidim-core", "~> #{s.version}"
  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "social-share-button", "~> 1.0.0"

  s.add_development_dependency "decidim-dev", "~> #{s.version}"
end
