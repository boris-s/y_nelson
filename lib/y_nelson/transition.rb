# Let's see whether just subclassing YPetri::Transition will do...
# 
class YNelson::Transition < YPetri::Transition
  include Yzz

  alias call along # .( :dimension ) instead of .along( :dimension )

  private

  # YNelson extends this YPetri::Transition private method, so that it creates
  # automatically a zz connection along dimension [:domain, i] for i-th domain
  # place of the transition.
  # 
  def inform_upstream_places
    upstream_places.each_with_index { |p, i|
      along( YNelson.Dimension :domain, i ) >> p
    }
    super
  end

  # YNelson extends this YPetri::Transition private method, so that it creates
  # automatically a zz connection along dimension [:codomain, i] for i-th
  # codomain place of the transition.
  # 
  def inform_downstream_places
    downstream_places.each_with_index { |p, i|
      along( YNelson.Dimension :codomain, i ) >> p
    }
    super
  end

  # Place, Transition, Net class.
  # 
  def Place; ::YNelson::Place end
  def Transition; ::YNelson::Transition end
  def Net; ::YNelson::Net end
end
