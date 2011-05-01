# -*- encoding: utf-8 -*-
require File.expand_path("../lib/instigator/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "instigator"
  s.version     = Instigator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = []
  s.email       = []
  s.homepage    = "http://rubygems.org/gems/instigator"
  s.summary     = "Project starter for Haskell"
  s.description = "Project starter for Haskell: sets up CI & github integration, along with best-practice stuff like tests and hlint"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "instigator"

  s.add_development_dependency "bundler", ">= 1.0.0.rc.6"
  s.add_dependency 'thor'
  s.add_dependency 'activesupport'
  s.add_dependency 'i18n'
  s.add_dependency 'uuid'
  s.add_dependency 'watchr'
  
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = ['lib','tasks']
end
