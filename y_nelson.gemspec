# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'y_nelson/version'

Gem::Specification.new do |spec|
  spec.name          = "y_nelson"
  spec.version       = YNelson::VERSION
  spec.authors       = ["boris"]
  spec.email         = ["\"boris@iis.sinica.edu.tw\""]
  spec.summary       = %q{A fusion of functional Petri net with a zz structure.}
  spec.description   = %q{Formalization and generalization of a spreadsheet.}
  spec.homepage      = ""
  spec.license       = "GPLv3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'yzz'
  spec.add_dependency 'y_petri'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  
  spec.required_ruby_version = '>= 2.0'
end
