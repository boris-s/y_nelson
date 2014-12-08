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
  spec.description   = %q{Zz structures are an interesting way of representing relations invented by Ted Nelson, whose domain model I provide in a gem Yzz. In this gem, YNelson, I combine Yzz with the universal Petri net provided by YPetri (another gem I wrote) to obtain a hybrid data structure that formalizes and generelizes a spreadsheet. Because let us note spreadsheets (as I have seen them) can be considered Petri nets of a kind, with cell functions acting as Petri net transitions. At the same time, spreadsheets are globally orthogonal structures with 3 typical dimensions (rows, columns and sheets). By using zz structures, the globally orthogonal spreadsheet is generalized as a locally orthogonal zz structure, with relations represented as zz dimensions, thus generalizing and formalizing a spreadsheet. The catch is that I have not yet finished the thinking process regarding what everything should be a zz object: Places (cells) and transitions definitely yes, but how about nets and dimensions? Should YNelson go as far as making namespaces into zz objects? The reason why these questions are hard to answer is because Ted Nelson himself, while providing interfaces guidelines (zz structure views, cursors...) did not comment on these questions. While being a (textual) DSL, YNelson aims to provide convenience on par with actual spreadsheet apps. Unlike YPetri, YNelson also aims to be able to specify more than one Petri net node per command, but this is still under development. See the user guide and the documentation for the details. YNelson documentation is available online, but due to formatting issues, you may prefer to generate the documentation on your own by running rdoc in the gem directory. For an example of how YPetri can be used to model complex dynamical systems, see the eukaryotic cell cycle model which I released as "cell_cycle" gem.}
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
