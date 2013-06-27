require 'y_support/all'

# Places are basically glorified variables, with current contents (marking), and
# default contents (default_marking).
#
class Place
  attr_reader :name, :default_marking
  attr_accessor :marking
  def initialize name, default_marking=0
    @name, @default_marking = name, default_marking
  end
  def reset!; @marking = default_marking end
end

# Transitions specify how marking changes when the transition "fires" (activates).
# "Arcs" attribute is a hash of { place => change } pairs.
#
class Transition
  attr_reader :name, :arcs
  def initialize( name, arcs: {} )
    @name, @arcs = name, arcs
  end
  def fire!
    arcs.each { |place, change| place.marking = place.marking + change }
  end
end

A, B, C = Place.new( "A" ), Place.new( "B" ), Place.new( "C" )

# Marking of A is incremented by 1
AddA = Transition.new( "AddA", arcs: { A => 1 } )

# 1 piece of A dissociates into 1 piece of B and 1 piece of C
DissocA = Transition.new( "DissocA", arcs: { A => -1, B => +1, C => +1 } )

[ A, B, C ].each &:reset!
[ A, B, C ].map &:marking #=> [0, 0, 0]
AddA.fire!
[ A, B, C ].map &:marking #=> [1, 0, 0]
DissocA.fire!
[ A, B, C ].map &:marking #=> [0, 1, 1]

require 'yaml'

class Place
  def to_yaml
    YAML.dump( { name: name, default_marking: default_marking } )
  end

  def to_ruby
    "Place( name: #{name}, default_marking: #{default_marking} )\n"
  end
end

puts A.to_yaml
puts B.to_yaml
puts C.to_yaml
puts A.to_ruby
puts B.to_ruby
puts C.to_ruby

class Transition
  def to_yaml
    YAML.dump( { name: name, arcs: arcs.modify { |k, v| [k.name, v] } } )
  end

  def to_ruby
    "Transition( name: #{name}, default_marking: #{arcs.modify { |k, v| [k.name.to_sym, v] }} )\n"
  end
end

puts AddA.to_yaml
puts DissocA.to_yaml
puts AddA.to_ruby
puts DissocA.to_ruby

# Now save that to a file
# and use

Place.from_yaml YAML.load( yaml_place_string )
Transition.from_yaml YAML.load( yaml_transition_string )
# or
YNelson::Manipulator.load( yaml: YAML.load( system_definition ) )

# then decorate #to_yaml and #to_ruby methods with Zz-structure-specific parts.

class Zz
  def to_yaml
    super + "\n" +
      YAML.dump( { along: dump_connectivity() } )
  end

  def to_ruby
    super + "\n" +
      "#{name}.along( #{dimension} ).posward #{along( dimension ).posward.name}\n" +
      "#{name}.along( #{dimension} ).negward #{along( dimension ).negward.name}"
  end
end

# etc.
