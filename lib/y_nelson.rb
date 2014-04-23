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
