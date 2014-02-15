# encoding: utf-8

# YNelson's user inteface. As the name suggests, represents an agent that
# manipulates the YNelson world. In his introduction to zz structures,
# Ted Nelson has remarks regarding the desired UI, such as:
#
# <em>Selection</em> is a pointer to a collection of cells.
# <em>View</em> consists of selection and a coordinate system.
# <em>Field<em> is a connected (contiguous) selection.
# <em>Coordinate system</em> is a collection of oriented dimensions.
#
# Apart from these author's suggestions, the interface should offer similar
# functionality as YPetri::Agent – that is, should allow constructing a Petri
# net with the same commands as YPetri does.
#
class YNelson::Agent
  attr_reader :world

  ★ YPetri::Agent::PetriNetRelated
  ★ YPetri::Agent::SimulationRelated

  # Future module YNelson::Agent::SimulationRelated

  # Calls #finalize before invoking YPetri::Agent#new_simulation.
  #
  def new_simulation *args; finalize; super end

  # Initialization of a YNelson::Agent instance. For YNelson manipulators, the
  # world is always YNelson itself.
  # 
  def initialize
    @world = ::YNelson
    super
    # A hash of sheets. (For the moment being, YNelson acts like a spreadsheet.)
    @sheets = {}
    # Default dimension of this manipulator.
    @default_dimension = YNelson.Dimension( :row )
    # Zz object pointers of this manipulator.
    @primary_point = YNelson::ZzPoint.new
    @secondary_point = YNelson::ZzPoint.new
    # Zz dimension pointers of this manipulator.
    @primary_dimension_point =
      YNelson::DimensionPoint.new YNelson.Dimension( :row )
    @secondary_dimension_point =
      YNelson::DimensionPoint.new YNelson.Dimension( :column )
    @todo = [] # array of blocks
  end

  # Now the part related to the zz structure itself, like in
  # module YNelson::Manipulator::ZzRelatedMethods
  #   blah blah
  # end
  # include YNelson::Manipulator::ZzRelatedMethods

  attr_reader :sheets

  # Dimension convenience constructor from 
  delegate :Dimension,
           to: :world
  
  # Now let's look into the graph visualization.

  def default_dimension
    @default_dimension
  end

  def primary_point
    @primary_point
  end
  alias p1 primary_point

  def secondary_point
    @secondary_point
  end
  alias p2 secondary_point

  def primary_dimension_point
    @primary_dimension_point
  end
  alias d1 primary_dimension_point

  def secondary_dimension_point
    @secondary_dimension_point
  end
  alias d2 secondary_dimension_point

  # Define function to display it with kioclient.
  # 
  def visualize *args, &block
    graphviz *args, &block
  end

  # Define graphviz places.
  # 
  def graphviz dim1=primary_dimension_point, dim2=secondary_dimension_point
    γ = GraphViz.new :G, type: :digraph  # Create a new graph

    # main        = γ.add_nodes( "main", shape: "box" )
    # parse       = γ.add_nodes( "parse", fillcolor: "yellow", style: "rounded,filled", shape: "diamond" )
    # execute     = γ.add_nodes( "execute", shape: "record", label: "{ a | b | c }", style: "rounded" )
    # init        = γ.add_nodes( "init", fillcolor: "yellow", style: "filled" )

    # set global node options
    γ.node[:color] = "#ddaa66"
    γ.node[:style] = "filled"
    γ.node[:shape] = "box"
    γ.node[:penwidth] = "1"
    γ.node[:fontname] = "Trebuchet MS"
    γ.node[:fontsize] = "8"
    γ.node[:fillcolor] = "#ffeecc"
    γ.node[:fontcolor] = "#775500"
    γ.node[:margin] = "0.0"

    # set global edge options
    γ.edge[:color] = "#999999"
    γ.edge[:weight] = "1"
    γ.edge[:fontsize] = "6"
    γ.edge[:fontcolor] = "#444444"
    γ.edge[:fontname] = "Verdana"
    γ.edge[:dir] = "forward"
    γ.edge[:arrowsize] = "0.5"

    # add zz objects
    place_nodes = places.map.with_object Hash.new do |place, ꜧ|
      ꜧ[place] = γ.add_nodes place.name.to_s
    end
    transition_nodes = transitions.map.with_object Hash.new do |transition, ꜧ|
      ꜧ[transition] = γ.add_nodes transition.name.to_s
    end
    nodes = place_nodes.merge transition_nodes
    # add edges for selected dimensions
    nodes.each { |instance, node|
      negward_neighbor = instance.( dim1 ).negward.neighbor
      nodes[ negward_neighbor ] << node if negward_neighbor # color 1
      negward_neighbor = instance.( dim2 ).negward.neighbor
      nodes[ negward_neighbor ] << node if negward_neighbor # color 2
    }

    γ.output png: "zz.png"        # Generate output image
    YSupport::KDE.show_file_with_kioclient File.expand_path( '.', "zz.png" )

    # main        = γ.add_nodes( "main", shape: "box" )
    # parse       = γ.add_nodes( "parse", fillcolor: "yellow", style: "rounded,filled", shape: "diamond" )
    # execute     = γ.add_nodes( "execute", shape: "record", label: "{ a | b | c }", style: "rounded" )
    # init        = γ.add_nodes( "init", fillcolor: "yellow", style: "filled" )
  end

  # graphviz [:domain, 0 ], [:codomain, 0]


  # Creation of a place governed by a single assignment transition. In other
  # words, creation of a place with a unary-output formula known well from
  # spreadsheets. The transition is named automatically by adding "_ϝ"
  # (digamma, resembles mathematical f used to denote functions) suffix to
  # the place's name, as soon as the place is named. For example,
  # 
  # Fred = PAT Joe do |joe| joe * 2 end
  # 
  # creates a place named "Fred" and an assignment transition named "Fred_ϝ"
  # that keeps Fred equal to 2 times Joe.
  #
  def PAT *domain, **named_args, &block
    Place().tap do |p| # place can be instantiated right away
      p.name = named_args.delete :name if named_args.has? :name, syn!: :ɴ
      @todo << -> {
        t = AT p, domain: domain, &block
        if p.name then t.name = "#{p.name}_ϝ" else
          # Rig the hook to name the transition as soon as the place is named.
          p.name_set_hook do |name| transition.name = "#{name}_ϝ" end
        end
        # Monkey-patch the place with default marking closure.
        p.define_singleton_method :default_marking do
          if has_default_marking? then local_variable_get :@default_marking else
            t.action_closure.( *t.domain.map( &:default_marking ) )
          end
        end
      }
    end
  end
  alias ϝ PAT

  # Executes all @todo closures.
  # 
  def finalize
    @todo.pop.call while not @todo.empty?
  end

  # ============================================================================
  # === THE METHODS BELOW ARE NOT REVIEWED FOR THE NEW VERSION AND NOT       ===
  # === EXPOSED IN THE DSL YET                                               ===
  # ============================================================================

  # Cell side referencers with r. to primary and secondary point
  def ξ_posward_side dim=nil; ::YTed::POINT.posward_side dim end
  alias :ξp :ξ_posward_side
  def ξ_negward_side dim=nil; ::YTed::POINT.negward_side dim end
  alias :ξn :ξ_negward_side
  def ξ2_posward_side dim=nil; ::YTed::POINT2.posward_side dim end
  alias :ξ2p :ξ2_posward_side
  def ξ2_negward_side dim=nil; ::YTed::POINT2.negward_side dim end
  alias :ξ2n :ξ2_negward_side

  # Point walkers
  def ξ_step_posward dim=nil; ::YTed::POINT.step_posward dim end
  alias :ξp! :ξ_step_posward
  def ξ_step_negward dim=nil; ::YTed::POINT.step_negward dim end
  alias :ξn! :ξ_step_negward
  def ξ2_step_posward dim=nil; ::YTed::POINT2.step_posward dim end
  alias :ξ2p! :ξ2_step_posward
  def ξ2_step_negward dim=nil; ::YTed::POINT2.step_negward dim end
  alias :ξ2n! :ξ2_step_negward

  # Point rank rewinders
  # (rewinders without exclamation mark expect block or return enumerator
  def ξ_rewind_posward *aa, &b; ::YTed::POINT.rewind_posward *aa, &b end
  alias :ξrp :ξ_rewind_posward
  def ξ_rewind_negward *aa, &b; ::YTed::POINT.rewind_negward *aa, &b end
  alias :ξpp :ξ_rewind_posward
  def ξ2_rewind_posward *aa, &b; ::YTed::POINT.rewind_posward *aa, &b end
  alias :ξ2rp :ξ2_rewind_posward
  def ξ2_rewind_negward *aa, &b; ::YTed::POINT.rewind_negward *aa, &b end
  alias :ξ2pp :ξ2_rewind_posward

  # Point rak rewinters with exclamation mark (no block or enum, just do it)
  def ξ_rewind_posward! dim=nil; ::YTed::POINT.rewind_posward! dim end
  alias :ξrn! :ξ_rewind_posward!
  alias :ξnn! :ξ_rewind_posward!
  def ξ_rewind_negward! dim=nil; ::YTed::POINT.rewind_negward! dim end
  alias :ξrn! :ξ_rewind_negward!
  alias :ξnn! :ξ_rewind_negward!
  def ξ2_rewind_posward! dim=nil; ::YTed::POINT2.rewind_posward! dim end
  alias :ξ2rp! :ξ2_rewind_posward!
  alias :ξ2pp! :ξ2_rewind_posward!
  def ξ2_rewind_negward! dim=nil; ::YTed::POINT2.rewind_negward! dim end
  alias :ξ2rn! :ξ2_rewind_negward!
  alias :ξ2nn! :ξ2_rewind_negward!

  # Neighbor referencers
  def ξ_posward_neighbor dim=nil; ::YTed::POINT.posward_neighbor dim end
  alias :ξP :ξ_posward_neighbor
  def ξ_negward_neighbor dim=nil; ::YTed::POINT.negward_neighbor dim end
  alias :ξN :ξ_negward_neighbor
  def ξ2_posward_neighbor dim=nil; ::YTed::POINT2.posward_neighbor dim end
  alias :ξ2P :ξ2_posward_neighbor
  def ξ2_negward_neighbor dim=nil; ::YTed::POINT2.negward_neighbor dim end
  alias :ξ2N :ξ2_negward_neighbor

  # Neighbor redefinition
  def ξ_redefine_posward_neighbor *args
    ::YTed::POINT.redefine_posward_neighbor *args end
  alias :ξP! :ξ_redefine_posward_neighbor
  def ξ_redefine_negward_neighbor *args
    ::YTed::POINT.redefine_negward_neighbor *args end
  alias :ξN! :ξ_redefine_negward_neighbor
  def ξ2_redefine_posward_neighbor *args
    ::YTed::POINT2.redefine_posward_neighbor *args end
  alias :ξ2P! :ξ2_redefine_posward_neighbor
  def ξ2_redefine_negward_neighbor *args
    ::YTed::POINT2.redefine_negward_neighbor *args end
  alias :ξ2N! :ξ2_redefine_negward_neighbor


  # FIXME these methods do not work well
  # #rank method creates a rank of connected cells along the given
  # dimension (named arg :dimension, alias :dΞ ), from values given as array
  # (named arg :array, alias :ᴀ). The rank is returned as a cell array.
  def zz_rank( array, dimension )
    array.map{ |e| ZzCell( e ) }.each_consecutive_pair{ |a, b|
      a.redefine_neighbors( dimension: dimension, posward: b )
    }
  end

  # Zips an array of ZzCells (receiver) with another array of ZzCells
  # in a given dimension. That is, each cell in the first array is made
  # to point (have posward neighbor) to the corresponding cell in the
  # second array.
  def zz_zip( cell_array, dimension )
    cell_array.a℈_all_∈( ::YTed::ZzCell )
    self.a℈_all_∈( ::YTed::ZzCell ).each.with_index{|cell, i|
      cell.redefine_neighbors( dimension: dimension,
                               posward: cell_array[i] )
    }
  end

  # All we need right now is use Zz as a spreadsheet, writing data in rows.

  # FIXME: Zz properites not used at all - classical Ruby data structures
  # are used instead. ξ is just a holder for sheet name

  # Creates a new row (rank along :row dimension) zipped to current row
  # along ξ.dim, using the supplied arguments as new row's cell values.
  def new_zz_row *args
    args = args[0].first if args.size == 1 and args[0].is_a? Hash
    previous_row = ( ::YTed::SHEETS[@current_sheet_name][-1] || [] ).dup
    row = args.map{ |a| ZzCell( a ) }
    row.each_consecutive_pair{ |a, b| a.P! x: b } # connect along :x
    row.each{ |e| e.N! y: previous_row.shift } # zip to previous row
    ::YTed::SHEETS[@current_sheet_name] << row
    if row[0].value.is_a? Symbol then
      ::YTed::SHEETS[@current_sheet_name]
        .define_singleton_method args[0] { row[1].aE_kind_of ::YPetri::Place }
    end
  end
  alias :→ :new_zz_row

  # #new_zz_sheet creates a new sheet with a single cell holding the sheet's
  # name and sets main point to it in :col dimenion sheet name as its value
  def new_zz_sheet( name )
    @current_sheet_name = name
    ::YTed::SHEETS[name] = []
    ::YTed::SHEETS
      .define_singleton_method name.to_sym do ::YTed::SHEETS[name] end
    return ::YTed::SHEETS[name]
  end
end
