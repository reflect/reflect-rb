# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "reflect/version"

Gem::Specification.new do |s|
  FILES = Dir[File.expand_path('../lib/**/*.rb', __FILE__)] + ['reflect.gemspec']

  s.name = "reflect"
  s.version = Reflect::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brad Heller"]
  s.date = "2015-08-30"
  s.description = "Ruby client for Reflect.io"
  s.email = "brad@reflect.io"
  s.files = FILES
  s.homepage = "http://github.com/reflect/reflect-rb"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Reflect.io API Ruby client"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_development_dependency('rake', '~> 10.1.0')
      s.add_development_dependency('minitest', '~> 5.3')
    else
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_development_dependency('rake', '~> 10.1.0')
      s.add_development_dependency('minitest', '~> 5.3')
    end
  else
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_development_dependency('rake', '~> 10.1.0')
    s.add_development_dependency('minitest', '~> 5.3')
  end
end


