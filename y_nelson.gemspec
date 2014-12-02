# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'y_nelson/version'

Gem::Specification.new do |spec|
  spec.name          = "y_nelson"
  spec.version       = YNelson::VERSION
  spec.authors       = ["boris"]
  spec.email         = ["\"boris@iis.sinica.edu.tw\""]
  spec.summary       = %q{A fusion of functional Petri net with a zz structure that formalizes and generalizes spreadsheet.}
  spec.description   = %q{Zz structures are an interesting way of representing relations invented by Ted Nelson. I captured the basic zz structure formalism in a gem Yzz. In this gem, YNelson, I combine zz structures with universal Petri nets (provided by another gem of mine, YPetri) to obtain a hybrid data structure that formalizes and generelizes spreadsheet. Because let us note that most practical spreadsheet implementation allow to model a Petri net with the cell functions – if the cell functions are regarded as transitions and cells and places, then a spreadsheet is a kind of a Petri net. At the same time, spreadsheet files are orthogonal structures with at least 3 dimensions: x (horizontal), y (vertical) and z (the dimension of sheets stacked upon each other). In addition, there is the "dimension" of files, the "dimension" of precedents and dependents (seen in formula auditing). If zz structures are used to represent relations as dimensions, this can be generalized, and the globally orthogonal nature of spreadsheets is generalized to the locally orthogonal nature of zz structures. The sum of this makes for a nice generalization of a spreadsheet, which YNelson attempts to be. In addition, YNelson attempts to provide convenience at least at the level similar to the actual existing spreadsheet software by providing certain commands that allow creation of more than one Petri net place or transition at the same time. This aspect of YNelson is still under development. See the user guide and the documentation for the details. YNelson documentation is available online, but due to formatting issues, you may prefer to generate the documentation on your own by running rdoc in the gem directory.}
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
