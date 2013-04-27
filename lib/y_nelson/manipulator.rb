# -*- coding: utf-8 -*-
# Although Nelson net itself is a singleton workspace, and thus has no
# counterpart of YPetri::Workspace, it admits existence of one or even more
# than one manipulator instance, representing user interface.
# 
class YNelson::Manipulator

  def initialize
    # SELECTION is a pointer to a collection of cells.
    # 
    # FIELD is a connected (contiguous) selection.
    # 
    # VIEW consists of SELECTION and a COORDINATE SYSTEM
    # 
    # COORDINATE SYSTEM is a collection of dimensions and their orientation
    # in a view (eg. 3-axis view we are used to from spreadsheets).
    # 
    # At the same time, each cell is a PLACE of a functional Petri net, and
    # thus has MARKING (=VALUE).
    # 
    # In a Petri net, PLACES are connected by arcs to TRANSITIONS, which can
    # change marking of the PLACES when they FIRE (#fire method).
    # 
    # Both places and transitions have DOMAIN (UPSTREAM objects) and CODOMAIN
    # (DOWNSTREAM objects). For transitions, TEST ARCS point upstream (to
    # input places) and ACTION ARCS point downstream (to output places).
    # 
    # A hash of sheets. (ZzCells have no problem to be a Zz structure and at
    # the same time members of standard Ruby data structures.)
    # 
    @sheets = {}
  end

  # Delegation of "workspace methods" directly to ... YTed::Nelson singleton class?
  delegate( :workspace_method_1,
            :workspace_method_2,
            :etc,
            to: YNelson )
  
  # Stand-in replacement for creation of a single-output formula, known so
  # well from existing spreadseet software. The method creates a new empty
  # place, and a new assignment transition whose single codomain arc extends
  # towards the created place. Pair [new_place, new_transition] is returned.
  # 
  def ϝ &block
    new_place = YNelson::Place.new
    new_transition = YNelson::Transition.new assignment: true,
                                    codomain: new_place,
                                    action: block
    return new_place, new_transition
  end


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

  def make_transitions
    # require 'debug'
    # LATER: When walking around the sheets, currently, there is no
    # protection against references to empty cells
    @transitions_to_make.map { |prescription|
      sheet = prescription[:sheet]
      type = prescription[:type]
      place = prescription[:place]
      block = prescription[:assignment_closure]

      case type
      when :unary_codomain_w_magic_block
        # PARAMETER MAGIC:
        # Blocks with specially named input arguments
        domain = block.parameters.map{ |e| e[1].to_s }.map{ |param|
          point = ZzPoint.new( place )
          if SHEETS.keys.include? sheet_name = param.split('_')[0] then
            # if the name consists of a sheet and parameter name, then ok
            rest = param[sheet_name.size + 1..-1]
            point = ZzPoint.new( SHEETS[sheet_name][0][0] )
            col = [*('a'..'z')].index rest[0]
            point.rewind_negward! :x
            if rest.size > 1 then # also change row, asssuming "a0" style
              point.rewind_negward! :y
              row = rest[1..-1].to_i
              row.times { point.step_posward :y }
            end
            col.times { point.step_posward :x }
            point.cell
          elsif [*('a'..'z')].include? param[0] then
            # if the name consists of an alphabetic letter...
            col = [*('a'..'z')].index param[0]
            point.rewind_negward! :x
            if param.size > 1 then # also change row, assuming "a0" style
              point.rewind_negward! :y
              row = param[1..-1].to_i
              row.times { point.step_posward :y }
            end
            col.times { point.step_posward :x }
            point.cell
          elsif param[0] = '_' then
            # Params named '_1', '_2', ... refer to different rows, same :col,
            # param named '__' refers to same cell
            if param == '__' then cell else
              i = param[1..-1].to_i
              point.rewind_negward! :y
              i.times { point.step_posward :x }
              point.cell
            end
          else
            raise TypeError, "unrecognized magic block parameter: #{param}"
          end
        } # block.parameters.map
        
        # Instantiate the new transition (do not fire it yet):
        Transition( domain: domain,
                    codomain: [ place ],
                    action_closure: block,
                    assignment_action: true )
      when :downstream_copy
        # DOWNSTREAM COPY
        # A single transition assigning upstream value to the downstream cell
        Transition( domain: prescription[:domain],
                                  codomain: [ place ],
                                  action_closure: λ {|v| v },
                                  assignment_action: true )
      else raise "Unknown transition prescription type: #{prescription[:type]}"
      end
    } # @transitions_to_make.map
  end

  # Places an order for a spreadsheet-like assignment transition. The order
  # will be fullfilled later when #make_transitions method is called.
  def new_downstream_cell &block
    # The place can be instatiated right away
    place = ZzCell( nil )

    # Transition making requests get remembered in @transitions_to_make:
    ( @transitions_to_make ||= [] ) <<
      { place: place,
        sheet: @current_sheet_name,
        assignment_closure: block,
        type: :unary_codomain_w_magic_block }
    return place
  end
  alias :ϝ :new_downstream_cell

  # Places an order for a spreadsheet-lie pure reference to another cell.
  def new_downstream_copy( cell )
    # Again, the place can be instantiated immediately
    p = ZzCell( nil )

    # And put the transition making request to @transitions_to_make:
    ( @transitions_to_make ||= [] ) <<
      { place: p, sheet: @current_sheet_name, domain: cell,
        type: :downstream_copy }
    return p
  end
  alias :↱ :new_downstream_copy
end
