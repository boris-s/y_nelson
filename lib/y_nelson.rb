# encoding: utf-8

require 'yzz'
require 'y_petri'
require 'y_support/kde'

require 'graphviz'

require_relative 'y_nelson/version'
require_relative 'y_nelson/yzz'
require_relative 'y_nelson/dimension'
require_relative 'y_nelson/place'
require_relative 'y_nelson/transition'
require_relative 'y_nelson/net'
require_relative 'y_nelson/zz_point'
require_relative 'y_nelson/dimension_point'
require_relative 'y_nelson/agent'
require_relative 'y_nelson/dsl'

# YNelson is an implementation of a cross between Ted Nelson's Zz structure,
# and a specific type of universal Petri net (PN), to whose creation I put
# particularly large amount of design considerations. The resulting data
# structure, combining the qualities of the said PN with those of a relational
# database, I refer to as Nelson net.
# 
# A Nelson net can be viewed as a genralization of a spreadsheet. Ted Nelson
# does note similarities between zz structures and spreadsheets and makes wide
# use of spreadsheet metaphors in his terminology: cells, rows, columns, ranks,
# cursors, selections... Nelson net arises by adding spreadsheet "formulas" to
# the mixture, which are nothing else than PN transitions.
# 
# From spreadsheet software implementations, we are used to various constraints
# regarding the available PN transitions. In Nelson nets, these constraints are
# removed by the Nelson nets being based on the said formally defined universal
# PN. Also, the plain globally orthogonal structure of rows/columns/sheets
# typical for spreadsheet implementations is generalized to the locally
# orthogonal zz structure with unlimited number of dimensions. The generalization
# is as follows:
#
# 1. Both places and transitions of the PN are zz objects.
# 2. The way the spreadsheet is based on PNs is properly formalized.
# 
# Luckily, Ted Nelson and his crowd already put energy into explaining the ins
# and outs of zz structures. There is a growing body of literature on this,
# including zz structure applications in bioinformatics. And I add to this my
# explanation of the extended PN type that I designed and implemented in YPetri
# gem (gem install YPetri), which is a dependency of YNelson.
# 
module YNelson
  # Singleton class of YNelson is a partial descendant of YPetri::World. It
  # aspires to be a database that represents the world. More specifically, it
  # mixes in most of the YPetri::World methods, and provides interface, which
  # is a superset of YPetri::World interface. The difference is, that while
  # YPetri::World can have multiple instances – workspaces in which we possibly
  # represent the world in different ways – YNelson::World is a singleton.
  # 
  class << self
    attr_reader :dimensions

    # Including instance methods of YPetri::World:
    include YPetri::World::PetriNetAspect
    include YPetri::World::SimulationAspect

    # Allows summoning YNelson::DSL by 'include YNelson'.
    # 
    def included receiver
      receiver.extend YNelson::DSL
      receiver.delegate :y_nelson_agent, to: "self.class"
    end

    # TODO: YNelson class, obviously, works. But there is something funny
    # about how it works. It seems that all the important methods, such
    # as Place(), Transition(), run!() don't go through the Agent (via
    # receiver.extend YNelson::DSL), but instead go directly through
    # include YPetri::World::PetriNetAspect and
    # include YPetri::World::SimulationAspect. While it is appropriate
    # that YNelson singleton class, since we have decided that it would
    # be basically a kind of YPetri::World, should have attributes of
    # YPetri::World, it is surprising that the method calls that are
    # supposed to be intercepted by the agent and only then sent to the
    # world, are handled by the world directly. This seems to be a problem
    # and a topic for the future refactor.

  end # class << self

  # Parametrize the Place / Transition / Net classes.
  param_class!( { Place: YNelson::Place,
                  Transition: YNelson::Transition,
                  Net: YNelson::Net },
                with: { world: self } )

  # Make them their own namespaces.
  [ Place(), Transition(), Net() ].each &:namespace!

  # Atypical initialize call.
  initialize
end

puts "YNelson: Nelson net domain model and simulator. ⓒ 2013 Boris Stitnicky"


# ===========================================================================
# !!! TODO !!!
# 
# Refactoring plans
# 
# When 'y_petri' is required, class Module will gain the capacity to respond
# to y_petri DSL commands (#Place, #Transition etc.).
# 
# This will allow syntax such as:
#
# # syntax 1
# 
# module Foo
#   P1 = Place()
#   P2 = Place()
#   P3 = Place()
# end
#
# module Bar
#   T1 = Transition s: { P1: -1, P2: 1 }
# end
#
# module Baz
#   T2 = Transition s: { P2: -1, P3: 1 }
# end
#
# In this syntax, there are two questions:
# 1. Which world will the defined nodes belong to?
# 2. Which net(s) will they be automatically included in?
#
# The goal here is to be able to construct things like:
#
# class Foobar
#   include Foo
#   include Bar
# end
#
# object = Foobar.new # Object with state defined by a net consisting
#                     # of Foo and Bar modules
#                     
# object.net          # YPetri net
# object.state        # state of the object's net
# 
# A different possibility would be to use the block syntax:
#
# # syntax 2
# 
# quux = net do
#   include "Foo"
#   Place "A", marking: 42
# end
#
# (Since net do A = Place( m: 42 ) end does not work -- constant gets
# defined in the callers scope.)
# 
# The question is, which world will the nodes defined by syntax 1 go to?
# I think that the world should be defined either:
#
# 1. explicitly
# 
# module Foo
#   self.y_petri_world = Bar
# end
#
# 2. implicitly
#
# module Foo
#   A = Place() # will automatically connect Foo with the default world
# end
# 
# module Foo::Bar
#   A = Place() # will search nesting and connect Foo::Bar with the world of Foo
# end
# 
# As for +YPetri::Net+ block constructor, the block should be module-evalled in
# the nascent instance (whose class descends from Module), but +include+ in it
# should be peppered so as to admit also Place and Transition arguments and to
# make the first include decide implicitly the world of this net.
#
# X = net do
#   include Foo::A
#   include Foo::Bar
# end
#
# Other than that, the world would have to be either defined explicitly
#
# X = foo_world.net do
#   # ...
# end
#
# or implicitly by Module#net, taking the module's world as the net's
# world, as in module definition.
#
# So Module#net would go somehow like:
#
# class Module
#   def net &block
#     x = Net.new
#     x.y_petri_world = y_petri_world # of the receiver
#     x.module_exec &block
#     return x
#   end
# end
#
# Object.y_petri_world is automatically created. World is not a module class.
#
# #net called outside a module should create a Net belonging to the
# Object.y_petri_world.
#
# ===========================================================================


# ===========================================================================
# !!! TODO !!!
# 
# Refactoring plans: Modules themselves should be ZZ objects, but not
# before yzz is refactored so as to allow to give the zz properties to
# already existing objects.
#
# It is a question whether all the objects should be zz objects, and the
# probable answer is actually yes.
