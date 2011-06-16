# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "orthrus/version"

Gem::Specification.new do |s|
  s.name        = "orthrus"
  s.version     = Orthrus::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Johannes Opper"]
  s.email       = ["xijo@gmx.de"]
  s.homepage    = "http://github.com/xijo/orthrus"
  s.summary     = %q{Remote method handling for Typhoeus}
  s.description = %q{Orthrus extends Typhoeus with remote method handling, since it is deprecated in Typhoeus itself.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'typhoeus', '~> 0.2'

  s.add_development_dependency 'test-unit', '~> 2.3'
  s.add_development_dependency 'json', '~> 1.5'
end
