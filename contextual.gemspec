# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "contextual/version"

Gem::Specification.new do |s|
  s.name        = "contextual"
  s.version     = Contextual::VERSION
  s.authors     = ["Ilya Grigorik"]
  s.email       = ["ilya@igvita.com"]
  s.homepage    = "https://github.com/igrigorik/contextual"
  s.summary     = "Runtime contextual autoescaper"
  s.description = s.summary

  s.rubyforge_project = "contextual"
  s.platform = "java"

  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
