# encoding: utf-8

module YNelson
  # YNelson DSL.
  # 
  module DSL
    def y_nelson_agent
      @y_nelson_agent ||= Agent.new
        .tap { puts "Defining YNelson agent for #{self}" if YNelson::DEBUG }
    end
  end

  delegate :world, to: :y_nelson_agent

  # Petri net aspect.
  delegate( :Place,
            :Transition, :T, :A,
            :Net,
            :place, :transition, :pl, :tr,
            :places, :transitions, :nets,
            :pn, :tn, :nn,
            :net_point,
            :net_selection,
            :net, :nnet,
            :net_point_reset,
            :net_point=,
            to: :y_nelson_agent )

  # Simulation aspect.
  delegate( :simulation_point, :ssc_point, :cc_point, :imc_point,
            :simulation_selection, :ssc_selection,
            :cc_selection, :imc_selection,
            :simulations,
            :clamp_collections,
            :initial_marking_collections,
            :simulation_settings_collections,
            :clamp_collection_names, :ncc,
            :initial_marking_collection_names, :nimc,
            :simulation_settings_collection_names, :nssc,
            :set_clamp_collection, :set_cc,
            :set_initial_marking_collection, :set_imc,
            :set_simulation_settings_collection, :set_ssc,
            :new_simulation,
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
            :plot_firing,
            :plot_gradient,
            :plot_delta,
            to: :y_nelson_agent )


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
            to: :y_nelson_agent )
end # module YNelson
