# -*- coding: utf-8 -*-

require 'yzz'
require 'y_petri'

require_relative 'y_nelson/version'
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

module YNelson
  # In YPetri, there are possibly multiple workspaces (files), a single
  # manipulator (the app interface), and delegations directly in module YPetri
  # for include, when one wants the DSL. Workspace instances have methods
  # which relate to the assets privately owned by the workspace.
  # 
  # Nelson net is different. Itself, it represents a persistent singleton
  # workspace. Therefore, the instance methods of YPetri::Workspace should
  # be owned by the singleton class of YTed::Nelson
  # 
  class << self
    # The Nelson net can be considered a YPetri::Workspace, and YTed::Nelson
    # will include its instance methods in its singleton class.
    include YPetri::Workspace::InstanceMethods

    # In order to allow to summon DSL by 'include YTed::Nelson', it should behave
    # somewhat like YPetri module.
    # 
    def included receiver
      # receiver.instance_variable_set :@NelsonManipulator, Manipulator.new
      # puts "included in #{receiver}"
      receiver.module_exec {
        define_method :nelson_manipulator do
          singleton_class.instance_variable_get :@NelsonManipulator or
            ( puts "defining Manipulator for #{self} singleton class" if YTed::DEBUG
              singleton_class.instance_variable_set :@NelsonManipulator, Manipulator.new )
        end
      }
    end

    def dimensions; @dimensions end
    def default_dimension; @default_dimension end
    def primary_point; @primary_point end
    def secondary_point; @secondary_point end
    def primary_dimension_point; @primary_dimension_point end
    def secondary_dimension_point; @secondary_dimension_point end
  end # class << self

  # Methods inherited from YPetri::Workspace::InstanceMethods expect instance
  # variables @Place, @Transition and @Net to refer to the appropriate classes
  # or parametrized subclasses:
  @Place, @Transition, @Net = self::Place, self::Transition, self::Net

  # Zz objects exist in multiple dimensions. Known from spreadsheets are:
  @dimensions = :row, :column, :sheet
  @default_dimension = :row
  @primary_point = self::ZzPoint.new
  @secondary_point = self::ZzPoint.new
  @primary_dimension_point = self::DimensionPoint.new
  @secondary_dimension_point = self::DimensionPoint.new

  initialize # normally, an instance method, called here in module execution

  delegate( :primary_point,
            :secondary_point,
            :primary_dimension_point,
            :secondary_dimension_point,
            :α, :β,
            :א, :ב,
            :ϝ,
            to: :nelson_manipulator )
  # TODO: Placing of Nelson manipulator instance is not completely correct.
end
