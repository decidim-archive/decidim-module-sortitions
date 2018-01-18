# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/sortitions/version"

Gem::Specification.new do |s|
  s.version = Decidim::Sortitions::VERSION
  s.authors = ["Juan Salvador Perez Garcia"]
  s.email = ["jsperezg@gmail.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-sortitions"
  s.required_ruby_version = ">= 2.3.1"

  s.name = "decidim-sortitions"
  s.summary = "This module makes possible to select amont a set of proposal by sortition"
  s.description = s.summary

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "Rakefile", "README.md", "LICENSE-AGPLv3.txt"]

  s.add_dependency "decidim-admin", "~> 0.9.0.pre"
  s.add_dependency "decidim-comments", "~> 0.9.0.pre"
  s.add_dependency "decidim-core", "~> 0.9.0.pre"
  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "social-share-button", "~> 1.0.0"

  s.add_development_dependency "decidim-dev", "~> 0.9.0.pre"
end
