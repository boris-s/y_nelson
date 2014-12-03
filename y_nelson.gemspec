# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'y_nelson/version'

Gem::Specification.new do |spec|
  spec.name          = "y_nelson"
  spec.version       = YNelson::VERSION
  spec.authors       = ["boris"]
  spec.email         = ["\"boris@iis.sinica.edu.tw\""]
  spec.summary       = %q{A fusion of a universal Petri net with a zz structure that formalizes and generalizes spreadsheet. As an extension of YPetri (y_petri) gem, YNelson inherits all its capabilities for modelling dynamical systems, but adds the capability to represent relations between model nodes and parameters.}
  spec.description   = %q{Zz structures are an interesting way of representing relations invented by Ted Nelson. I captured the basic zz structure formalism in a gem Yzz. In this gem, YNelson, I combine zz structures with universal Petri nets (provided by another gem of mine, YPetri) to obtain a hybrid data structure that formalizes and generelizes a spreadsheet. Because let us note that most of the practical spreadsheet implementations allow the cell functions to be used so as to represent a Petri net. The cell functions can thus be regarded as transitions and cells and places of a Petri net. A spreadsheet is thus a kind of a Petri net. At the same time, spreadsheet files are orthogonal structures with at least 3 dimensions: x (horizontal), y (vertical) and z (the dimension of sheets stacked upon each other). With zz structures, the globally orthogonal nature traditional spreadsheet is generalized as a locally orthogonal zz structure, with relations represented as zz dimensions. In sum, this generalizes and formalizes a spreadsheet. While being textual at the core, YNelson attempts to provide convenience at least at the level similar to the actual existing spreadsheet software. Unlike YPetri, YNelson can also specify more than one node per command, but this is still under development. See the user guide and the documentation for the details. YNelson documentation is available online, but due to formatting issues, you may prefer to generate the documentation on your own by running rdoc in the gem directory. For an example of how YPetri can be used to model complex dynamical systems, see the eukaryotic cell cycle model which I released as "cell_cycle" gem.}
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
