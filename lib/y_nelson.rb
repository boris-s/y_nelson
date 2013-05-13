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

# YNelson is an implementation of a cross between Ted Nelson's Zz structure, and
# a functional Petri net (FPN). The resulting data structure, which combines
# qualities of FPNs with those of relational databases, I refer to as Nelson net
# throughout this text.
# 
# One way to understand Nelson nets is as a genralization of a spreadsheet. In
# his explanations of Zz structures, Ted Nelson makes wide use of spreadsheet
# metaphors: cells, ranks, rows, columns, cursors, selections... Nelson net
# implemented here adds "formulas" to the mix, represented by FPN transitions.
# 
# Nelson net disposes of the arbitrary constraints on FPNs as well as the
# orthogonal structure of "cells" seen in most practical spreadsheet
# implementations:
# 
# 1. Both places and transitions of the FPN take part in zz structure.
# 2. Formula-based transitions are upgraded to standalone FPN transitions.
# 
# The implications of the zz structure differences from ordinary hyperorthogonal
# structures hav been, to a degree, explained by Ted Nelson himself. There is a
# growing body of literature on zz structure applications, including in
# bioinformatics.
#
# As for functional Petri nets, their power in computing is well recognized (eg.
# Funnel, Odersky 2000). FPNs are sometimes just called functional nets, because
# Petri originally described his nets as timeless and functionless. However, in
# special-purpose applications, such as biochemical applications, to which I
# incline, it is appropriate to honor Petri, who designed his nets specifically
# with chemical modeling in mind as one of their main applications. In
# biochemistry, it is common to call functional nets Petri nets (Miyano, 200?).
# 
module YNelson
  # Singleton class of YNelson is partial descendant of YPetri::Workspace. More
  # specifically, it mixes in most YPetri::Workspace instance methods and
  # provides interface, which should be a superset of YPetri::Workspace. The
  # difference is, that while YPetri::Workspace can have multiple instances,
  # representing workdesks, YNelson is a singleton representing relational
  # database.
  # 
  class << self
    # YNelson metaclass includes instance methods of YPetri::Workspace.
    include YPetri::Workspace::PetriNetRelatedMethods
    include YPetri::Workspace::SimulationRelatedMethods

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

  # Atypical call to #initialize in the course of module execution.
  initialize
  
  delegate( :workspace, to: :y_nelson_manipulator )

  # Petri net aspect.
  delegate( :Place, :Transition, :Net,
            :place, :transition, :pl, :tr,
            :places, :transitions, :nets,
            :pp, :tt, :nn,
            :net_point,
            :net_selection,
            :net, :ne,
            :net_point_reset,
            :net_point_set,
            to: :y_nelson_manipulator )

  # Simulation aspect.
  delegate( :simulation_point, :ssc_point, :cc_point, :imc_point,
            :simulation_selection, :ssc_selection,
            :cc_selection, :imc_selection,
            :simulations,
            :clamp_collections,
            :initial_marking_collections,
            :simulation_settings_collections,
            :clamp_collection_names, :cc_names,
            :initial_marking_collection_names, :imc_names,
            :simulation_settings_collection_names, :ssc_names,
            :set_clamp_collection, :set_cc,
            :set_initial_marking_collection, :set_imc,
            :set_simulation_settings_collection, :set_ssc,
            :new_timed_simulation,
            :clamp_cc, :initial_marking_cc, :simulation_settings_cc,
            :simulation_point_position,
            :simulation,
            :clamp_collection, :cc,
            :initial_marking_collection, :imc,
            :simulation_settings_collection, :ssc,
            :clamp,
            :initial_marking,
            :set_step, :set_step_size,
            :set_time, :set_target_time,
            :set_sampling,
            :set_simulation_method,
            :new_timed_simulation,
            :run!,
            :print_recording,
            :plot,
            :plot_selected,
            :plot_state,
            :plot_flux,
            to: :y_nelson_manipulator )

  # Zz aspect.
  delegate( :Dimension,
            :ϝ,
            :default_dimension,
            :primary_point, :p1,
            :secondary_point, :p2,
            :primary_dimension_point, :d1,
            :secondary_dimension_point, :d2,
            :visualize,
            :graphviz,
            to: :nelson_manipulator )
end
