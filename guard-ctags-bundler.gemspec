# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/ctags-bundler/version"

Gem::Specification.new do |s|
  s.name        = "guard-ctags-bundler"
  s.version     = Guard::Ctags::Bundler::VERSION
  s.authors     = ["Ivan Tkalin"]
  s.email       = ["itkalin@gmail.com"]
  s.homepage    = "https://github.com/ivalkeen/guard-ctags-bundler"
  s.summary     = %q{Guard gem for generating ctags for project files and gems from project's bundle.}
  s.description = %q{Guard::CtagsBundler uses ctags utility and generates 2 files: tags -- with tags generated from project's source tree and gems.tags -- with tags generated from rubygems from project's bundle.}

  s.rubyforge_project = "guard-ctags-bundler"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency 'guard', '>= 0.4.0'

  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
