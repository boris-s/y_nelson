#encoding: utf-8

# A pointer to a Zz object. A glorified variable, basically.
# 
class YNelson::ZzPoint
  attr_accessor :zz

  # Initialization has one optional argument :zz -- zz object at which the
  # point should be initialized.
  # 
  def initialize( zz: nil )
    @zz = zz
  end

  delegate :marking, :value, :υ,
           :marking=, :value=, :υ=,
           :test_arcs, :codomain, :downstream_transitions,
           :action_arcs, :domain, :upstream_transitions, :ϝ, # digamma: ϝ
           :arcs, # :connectivity alias not delegated to avoid confusion
           :upstream_places, # :precedents, :← not delegated, same reason
           :downstream_places, # :dependents, :→ aliases not delegated
           to: :zz
  alias :v :value

  def default_dimension; YNelson.primary_dimension end

  # Quasi-delegation to zz

  def along dimension=default_dimension
    zz.along dimension
  end

  def posward( along: default_dimension )
    along( along ).posward
  end
  alias p posward

  def negward( along: default_dimension )
    along( along ).negward_side
  end
  alias n negward

  def posward_neighbor( along: default_dimension )
    posward( along: along ).neighbor
  end
  alias P posward_neighbor

  def negward_neighbor( along: default_dimension )
    negward( along: along ).neighbor
  end
  alias N negward_neighbor

  def redefine_posward_neighbor( neighbor, along: default_dimension )
    posward( along: along ) << neighbor
  end
  alias P! :redefine_posward_neighbor

  def redefine_negward_neighbor( neighbor, along: default_dimension )
    negward( along: along ) << neighbor
  end
  alias N! :redefine_negward_neighbor

  def bud_posward( value=nil, along: default_dimension )
    posward( along: along ).bud value
  end
  alias bud bud_posward

  def bud_negward( value=nil, along: default_dimension )
    negward( along: along ).bud value
  end

  def rank( along: default_dimension )
    zz.get_rank along: along
  end

  # Walkers

  def step_posward( along: default_dimension )
    neighbor = posward_neighbor along: along
    if neighbor.is_a_zz? then @zz = neighbor else false end
  end
  alias step step_posward
  alias p! step_posward

  def step_negward( along: default_dimension )
    neighbor = negward_neighbor along: along
    if neighbor.is_a_zz? then @zz = neighbor else false end
  end
  alias n! step_negward

  # Rewinders

  def rewind_posward( along: default_dimension )
    origin = zz
    if block_given? then
      loop { yield zz
             return :end unless posward_neighbor( along: along ).is_a_zz?
             return :loop if posward_neighbor( along: along ) == origin
             step_posward along: along }
    else # no block given, returns enumerator
      Enumerator.new { |y|
        loop { y << zz
               break :end unless posward_neighbor( along: along ).is_a_zz?
               break :loop if posward_neighbor( along: along ) == origin
               step_posward along: along }
      }
    end
  end

  def rewind_negward( along: default_dimension )
    origin = zz
    if block_given? then
      loop { yield zz
             return :end unless negward_neighbor( along: along ).is_a_zz?
             return :loop if negward_neighbor( along: along ) == origin
             step_negward along: along }
    else
      Enumerator.new { |y|
        loop { y << zz
               break :end unless negward_neighbor( along: along ).is_a_zz?
               break :loop if negward_neighbor( along: along ) == origin
               step_negward along: along }
      }
    end
  end

  # Simple unconditional rewind.

  def rewind_posward!( along: default_dimension )
    rewind_posward( along: along ) {} # implemented using empty block
  end

  def rewind_negward!( along: default_dimension )
    rewind_negward( along: along ) {}
  end
end # class YNelson::ZzPoint
