# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "orthrus/version"

Gem::Specification.new do |s|
  s.name        = "orthrus"
  s.version     = Orthrus::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Johannes Opper"]
  s.email       = ["xijo@gmx.de"]
  s.homepage    = ""
  s.summary     = %q{Orthrus: extends Typhoeus with remote method handling}
  s.description = %q{Thats it!}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'typhoeus'
end
