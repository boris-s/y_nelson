# YNelson::Transition is based on YPetri::Transition and offers similar
# interface. "Functions", on which transitions of a functional Petri net
# are based, are analogical to 'formulas' of a spreadsheet.
# 
class YNelson::Transition < YPetri::Transition
  include YNelson::Yzz
  alias call along # .( :dim ) rather than .along( :dim )

  private

  # YNelson extends this YPetri::Transition private method, so that a zz
  # connection is automatically created along dimension [:domain, i] for
  # i-th domain place of the transition.
  # 
  def inform_upstream_places
    upstream_places.each_with_index { |p, i|
      along( YNelson.Dimension self, :domain, i ) >> p
    }
    super
  end

  # YNelson extends this YPetri::Transition private method, so that a zz
  # connection is autimatically created along along dimension [:codomain, i]
  # for i-th codomain place of the transition.
  # 
  def inform_downstream_places
    downstream_places.each_with_index { |p, i|
      along( YNelson.Dimension self, :codomain, i ) >> p
    }
    super
  end

  # Produces the inspect string of the place.
  # 
  def inspect
    # Calling the ancestor's #inspect.
    YPetri::Transition.instance_method( :inspect ).bind( self ).call
  end

  # Returns a string briefly describing the place.
  # 
  def to_s
    YPetri::Transition.instance_method( :to_s ).bind( self ).call
  end
end
