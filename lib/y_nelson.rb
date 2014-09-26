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

# YNelson is an implementation of a cross between Ted Nelson's Zz structure, and
# the functional Petri net (FPN). The resulting data structure, which combines
# the qualities of FPNs with those of relational databases, I refer to as Nelson
# net throughout this text.
# 
# A Nelson net, from a certain point of view, is as a genralization of a
# spreadsheet software. In his explanations of Zz structures, Ted Nelson makes
# wide use of metaphors well known from spreadsheets: cells, ranks, rows,
# columns, cursors, selections... Nelson net, as implemented here, adds
# "formulas" to the mix: Spreadsheet "formulas" are simply represented by FPN
# transitions.
# 
# Nelson net disposes of the arbitrary constraints on FPNs, and also extends the
# plain orthogonal structure of spreadsheet "cells", as can be seen in the
# existing spreadsheet implementations:
# 
# 1. Both places and transitions of the FPN take part in zz structure.
# 2. Formula-based transitions are upgraded to standalone FPN transitions.
# 
# The implications of the differences of a zz structure from ordinary
# hyperorthogonal structures have been, to a degree, explained by Ted Nelson
# himself. There is a growing body of literature on zz structure applications,
# including the applications in bioinformatics.
#
# As for functional Petri nets, their power in computing is well recognized (eg.
# Funnel, Odersky 2000). FPNs are sometimes just called functional nets, because
# Petri originally described his nets as timeless and functionless. However, in
# special-purpose applications, such as biochemical applications, to which I
# incline, it is appropriate to honor Petri, who designed his nets specifically
# with chemical modeling in mind. In biochemistry, it is common to call
# functional nets Petri nets (Miyano, 200?).
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
