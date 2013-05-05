# -*- coding: utf-8 -*-
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
require_relative 'y_nelson/manipulator'

# Spreadsheet software, which we all know, is based on a data structure, which
# can be formalized a combination of 2 aspects:
#
# 1. Orthogonal structure
# 2. Network of cell formulas and their mutual connections
# 
# The orthogonal structure has dimensions (horizontal rows, vertical columns,
# sheets, files...) The network of cell formulas, in most spreadsheets, bears
# semblance to a functional Petri net (FPN). 
# 
# Here, I formalize and generalize the spreadsheet idea as follows:
# 
# 1. Spreadsheet orthogonal structure is upgraded to Ted Nelson's Zz structure
# 2. Network of cell formulas is upgraded to a genuine FPN.
# 
# The resulting FPN whose places and transitions form a Zz structure, I call
# Nelson net. Zz structure makes Nelson net considerably different from
# conventional orthogonal structures seen in spreadsheets, databases and such.
# The implications of these differences have been, to a degree, explained by
# Ted Nelson, and the growing body of literature on Zz structures. In his
# discussion of Zz structures, Ted Nelson himself already introduces the concepts
# related to not only the data structure, but also to its presentation in a
# user interface.
#
# As for the Petri net aspect, formula network of arbitrary spreadsheet can be
# described by a suitable FPN. The opposite, however, does not hold -- current
# spreadsheet implementations (that I know of), have implementation details, that
# prevent them from directly representing full-fledged FPNs. Although
# special-purpose Petri net software exists, spreadsheet developers seem to
# proceed intuitively, without active efforts towards explicit, full fledged
# FPN implementation. Nelson net described here is an attempt to formalize these
# engineering efforts.
# 
module YNelson
  # YNelson is a singleton partial descendant of YPetri::Workspace. More
  # specifically, its singleton class mixes in most instance methods of
  # YPetri::Workspace and provides interface, which is a superset of
  # YPetri::Workspace. While YPetri::Workspace can have multiple instances,
  # representing workdesks, YNelson is a singleton representing relational
  # database.
  # 
  class << self
    # YNelson metaclass includes instance methods of YPetri::Workspace.
    include YPetri::Workspace::InstanceMethods

    # Allows summoning DSL by 'include YNelson' (like YPetri does).
    # 
    def included receiver
      # receiver.instance_variable_set :@NelsonManipulator, Manipulator.new
      # puts "included in #{receiver}"
      receiver.module_exec {
        define_method :nelson_manipulator do
          singleton_class.instance_variable_get :@NelsonManipulator or
            ( puts "defining Manipulator for #{self} singleton class" if YNelson::DEBUG
              singleton_class.instance_variable_set :@NelsonManipulator, Manipulator.new )
        end
      }
    end

    def dimensions; @dimensions end
  end # class << self

  # Instance variables @Place, @Transition, @Net are expected by
  # YPetri::Workspace module.
  @Place, @Transition, @Net = self::Place, self::Transition, self::Net

  initialize # Atypical call to #initialize in the course of module execution.

  delegate( :primary_point,
            :secondary_point,
            :primary_dimension_point,
            :secondary_dimension_point,
            :place, :transition, :net,
            :α, :β,
            :א, :ב,
            :ϝ,
            :visualize,
            to: :nelson_manipulator )
end
